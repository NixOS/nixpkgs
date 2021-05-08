{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
}:

buildPythonPackage rec {
  pname = "python-velbus";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "thomasdelaet";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dv7dsjp5li87ispdphaz7jd0a9xc328rxwawf2f58b1ii904xr4";
  };

  propagatedBuildInputs = [ pyserial ];

  # Project has not tests
  doCheck = false;
  pythonImportsCheck = [ "velbus" ];

  meta = with lib; {
    description = "Python library to control the Velbus home automation system";
    homepage = "https://github.com/thomasdelaet/python-velbus";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
