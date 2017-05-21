{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, nose, unrar, glibcLocales }:

buildPythonPackage rec {
  name = "rarfile-${version}";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "markokr";
    repo = "rarfile";
    rev = "rarfile_3_0";
    sha256 = "07yliz6p1bxzhipnrgz133gl8laic35gl4rqfay7f1vc384ch7sn";
  };
  buildInputs = [ pytest nose glibcLocales ];

  prePatch = ''
    substituteInPlace rarfile.py \
      --replace 'UNRAR_TOOL = "unrar"' "UNRAR_TOOL = \"${unrar}/bin/unrar\""
  '';
  LC_ALL = "en_US.UTF-8";
  checkPhase = ''
    py.test test -k "not test_printdir"
  '';

  meta = with stdenv.lib; {
    description = "RAR archive reader for Python";
    homepage = https://github.com/markokr/rarfile;
    license = licenses.isc;
  };
}
