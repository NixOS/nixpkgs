{ stdenv, fetchurl, findXMLCatalogs

# Optional Dependencies
, icu ? null, python ? null, readline ? null, zlib ? null, xz ? null
}:

#TODO: share most stuff between python and non-python builds, perhaps via multiple-output

let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}${if val != null && cond != false then "=${val}" else ""}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";
  mkOther = mkFlag "" "" true;

  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  optIcu = shouldUsePkg icu;
  optPython = shouldUsePkg python;
  optReadline = shouldUsePkg readline;
  optZlib = shouldUsePkg zlib;
  optXz = shouldUsePkg xz;

  sitePackages = if optPython == null then null else
    "\${out}/lib/${python.libPrefix}/site-packages";
in
stdenv.mkDerivation rec {
  name = "libxml2-${version}";
  version = "2.9.2";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "1g6mf03xcabmk5ing1lwqmasr803616gb2xhn7pll10x2l5w6y2i";
  };

  buildInputs = [ optIcu optPython optReadline optZlib optXz ];
  propagatedBuildInputs = [ findXMLCatalogs ];

  configureFlags = [
    (mkWith (optIcu != null)      "icu"                optIcu)
    (mkWith (optPython != null)   "python"             optPython)
    (mkWith (optPython != null)   "python-install-dir" sitePackages)
    (mkWith (optReadline != null) "readline"           optReadline)
    (mkWith (optZlib != null)     "zlib"               optZlib)
    (mkWith (optXz != null)       "lzma"               optXz)
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://xmlsoft.org/;
    description = "An XML parsing library for C";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eelco wkennington ];
  };

  passthru = {
    inherit version;
    pythonSupport = python != null;
  };
}
