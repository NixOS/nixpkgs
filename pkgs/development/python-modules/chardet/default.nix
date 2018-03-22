{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestrunner, hypothesis }:

buildPythonPackage rec {
  pname = "chardet";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bpalpia6r5x1kknbk11p1fzph56fmmnp405ds8icksd3knr5aw4";
  };

  checkInputs = [ pytest pytestrunner hypothesis ];

  meta = with stdenv.lib; {
    homepage = https://github.com/chardet/chardet;
    description = "Universal encoding detector";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
