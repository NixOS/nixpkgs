{ lib, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "puremagic";
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "025ih5q1qa40x88j7ngsdr5sf0dp400kwlfzz60i7v6fh0ms1zkg";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"argparse"' ""
  '';

  # test data not included on pypi
  doCheck = false;

  pythonImportsCheck = [ "puremagic" ];

  meta = with lib; {
    description = "Pure python implementation of magic file detection";
    license = licenses.mit;
    homepage = "https://github.com/cdgriffith/puremagic";
    maintainers = with maintainers; [ globin ];
  };
}
