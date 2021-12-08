{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, mock
, blessings
, nose
, nose_progressive
, pillow
, args
, pkgs
}:

buildPythonPackage rec {
  pname = "clint";
  version = "0.5.1";

  src = fetchFromGitHub {
     owner = "kennethreitz";
     repo = "clint";
     rev = "v0.5.1";
     sha256 = "1qv7d8h16klk3n9a8aw6bldpg3gxvvpffzrwjwq83yjrynn1psww";
  };

  LC_ALL="en_US.UTF-8";

  checkPhase = ''
    ${python.interpreter} test_clint.py
  '';

  buildInputs = [ mock nose nose_progressive pkgs.glibcLocales ];
  propagatedBuildInputs = [ pillow blessings args ];

  meta = with lib; {
    homepage = "https://github.com/kennethreitz/clint";
    description = "Python Command Line Interface Tools";
    license = licenses.isc;
    maintainers = with maintainers; [ domenkozar ];
  };

}
