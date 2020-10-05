{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, nose, libarchive, glibcLocales
# unrar is non-free software
, useUnrar ? false, unrar
}:

assert useUnrar -> unrar != null;
assert !useUnrar -> libarchive != null;

buildPythonPackage {
  pname = "rarfile";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "markokr";
    repo = "rarfile";
    rev = "v${version}";
    sha256 = "0hzlrbl5vsxsw2vn5k20yyzc0xrp7bsdgy0m9d1dxdgsv3q5ilwz";
  };
  buildInputs = [ pytest nose glibcLocales ];

  prePatch = ''
    substituteInPlace rarfile.py \
  '' + (if useUnrar then
        ''--replace 'UNRAR_TOOL = "unrar"' "UNRAR_TOOL = \"${unrar}/bin/unrar\""
        ''
       else
        ''--replace 'ALT_TOOL = "bsdtar"' "ALT_TOOL = \"${libarchive}/bin/bsdtar\""
        '')
     + ''
   '';
  # the tests only work with the standard unrar package
  doCheck = useUnrar;
  LC_ALL = "en_US.UTF-8";
  checkPhase = ''
    py.test test -k "not test_printdir"
  '';

  meta = with stdenv.lib; {
    description = "RAR archive reader for Python";
    homepage = "https://github.com/markokr/rarfile";
    license = licenses.isc;
  };
}
