{
  buildPythonPackage,
  exempi,
  fetchFromGitHub,
  pytz,
  lib,
  stdenv,
}:

buildPythonPackage {
  pname = "python-xmp-toolkit";
  version = "2.0.2";
  format = "setuptools";

  # PyPi has version 2.0.1; the tests fail
  # There are commits for a 2.0.2 release that was never published
  # Not to github, not to PyPi
  # This is the latest commit from Jun 29, 2017 (as of Mar 13, 2019)
  # It includes the commits for the unreleased version 2.0.2 and more
  # Tests pass with this version
  src = fetchFromGitHub {
    owner = "python-xmp-toolkit";
    repo = "python-xmp-toolkit";
    rev = "5692bdf8dac3581a0d5fb3c5aeb29be0ab6a54fc";
    sha256 = "16bylcm183ilzp7mrpdzw0pzp6csv9v5v247914qsv2abg0hgl5y";
  };

  buildInputs = [ exempi ];

  propagatedBuildInputs = [ pytz ];

  postPatch = ''
    substituteInPlace libxmp/exempi.py \
      --replace "ctypes.util.find_library('exempi')" "'${exempi}/lib/libexempi${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  # hangs on darwin + sandbox
  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    rm test/{test_exempi,test_files}.py
  '';

  meta = with lib; {
    homepage = "https://github.com/python-xmp-toolkit/python-xmp-toolkit";
    description = "Python XMP Toolkit for working with metadata";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
