{ stdenv, fetchurl, findXMLCatalogs

# Optional Dependencies
, icu ? null, python ? null, readline ? null, zlib ? null, xz ? null
}:

#TODO: share most stuff between python and non-python builds, perhaps via multiple-output

with stdenv;
let
  optIcu = shouldUsePkg icu;
  optPython = shouldUsePkg python;
  optReadline = shouldUsePkg readline;
  optZlib = shouldUsePkg zlib;
  optXz = shouldUsePkg xz;

  sitePackages = if optPython == null then null else
    "\${out}/lib/${python.libPrefix}/site-packages";
in
with stdenv.lib;
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
