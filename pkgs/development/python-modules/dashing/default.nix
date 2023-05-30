{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "dashing";
  version = "0.1.0";
  format = "setuptools";

  disabled = python3.pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JRRgjg8pp3Xb0bERFWEhnOg9U8+kuqL+QQH6uE/Vbxs=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    blessed
  ];

  meta = with lib; {
    homepage = "https://github.com/FedericoCeratto/dashing";
    description = "Terminal dashboards for Python";
    license = licenses.gpl3;
    maintainers = with maintainers; [ juliusrickert ];
  };
}
