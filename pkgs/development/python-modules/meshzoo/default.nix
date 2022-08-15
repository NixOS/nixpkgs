{ lib
, fetchurl
, buildPythonPackage
, x21
, kgt
, numpy
}:

buildPythonPackage rec {
  pname = "meshzoo";
  version = "0.9.11";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/67/b8/7b9754f15b8a26665787e8ee276e721dbe5bb1991f2c8ac02443004c5460/meshzoo-0.9.11-py3-none-any.whl";
    sha256 = "sha256-3FM+lqNzwnTxEQKFQADSd26CY3TcxKIXURO5K4z/Gdo=";
  };

  propagatedBuildInputs = [
    kgt
    numpy
    x21
  ];

  pythonImportsCheck = [ "meshzoo" ];

  meta = with lib; {
    description = "Collection of explicitly constructed meshes";
    homepage = "https://github.com/meshpro/meshzoo";
    # Unspecified license therefore unfree
    # https://github.com/meshpro/meshzoo/issues/94
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
  };
}
