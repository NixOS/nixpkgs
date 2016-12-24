{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, pcre, gmp, mpfr, gtkdoc, docbook_xsl
, python3Packages
# Only needed for tests:
, glibcLocales
}:

stdenv.mkDerivation rec {
  name = "libbytesize-${version}";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "libbytesize";
    rev = version;
    sha256 = "1khdfbx316aq4sbw4g2dgzwqi1nbw76rbwjmjx6libzsm6ibbsww";
  };

  postPatch = ''
    sed -i -e 's,libbytesize.so.1,'"$out/lib/"'&,' src/python/bytesize.py
  '';

  XML_CATALOG_FILES = "${docbook_xsl}/xml/xsl/docbook/catalog.xml";

  buildInputs = [
    python3Packages.python pcre gmp mpfr
    # Only needed for tests:
    python3Packages.pocketlint glibcLocales
  ];
  nativeBuildInputs = [ autoreconfHook pkgconfig gtkdoc ];
  propagatedBuildInputs = [ python3Packages.six ];

  doInstallCheck = true;
  installCheckTarget = "check";
  preInstallCheck = "patchShebangs tests";

  meta = {
    homepage = "https://github.com/rhinstaller/libbytesize";
    description = "Library for working with arbitrary big sizes in bytes";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
