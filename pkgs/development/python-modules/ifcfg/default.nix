{ lib
, fetchFromGitHub
, python3Packages
, iproute2
}:

python3Packages.buildPythonPackage rec{
  pname = "ifcfg";
  version = "0.23";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ftao";
    repo = "python-ifcfg";
    rev = "releases/${version}";
    hash = "sha256-j621Yx/LjLaHPZ1N95cUSGxl0qESISS+HeQJRETLeoo=";
  };

  propagatedBuildInputs = [ iproute2 ];

  checkInputs = with python3Packages; [ nose mock iproute2 ];

  pythonImportsCheck = [ "ifcfg" ];

  meta = with lib; {
    description = "A library for parsing ifconfig and ipconfig output";
    homepage = "https://github.com/ftao/python-ifcfg";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ beezow ];
  };
}
