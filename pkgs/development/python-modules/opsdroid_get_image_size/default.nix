{ lib, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "opsdroid_get_image_size";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "124j2xvfxv09q42qfb8nqlcn55y7f09iayrix3yfyrs2qyzav78a";
  };

  # test data not included on pypi
  doCheck = false;

  pythonImportsCheck = [ "get_image_size" ];

  meta = with lib; {
    description = "Get image width and height given a file path using minimal dependencies";
    license = licenses.mit;
    homepage = "https://github.com/opsdroid/image_size";
    maintainers = with maintainers; [ globin ];
  };
}
