{ lib, buildPythonPackage, fetchPypi,
  django, nose, pillow, sampledata, six, versiontools
}:

buildPythonPackage rec {
  pname = "django-sampledatahelper";
  version = "0.5";

  meta = {
    description = "Helper class for generate sample data for django apps development";
    homepage = "https://github.com/kaleidos/django-sampledatahelper";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fbc5533f1055f9d1944097f6271e8b18fcf4ed5cc582b518616445145300015";
  };

  buildInputs = [ django nose pillow sampledata six versiontools ];
  propagatedBuildInputs = [ django sampledata ];

  # HACK To prevent collision with pythonPackages.sampledata
  preBuild = ''
    rm tests/*
  '';

  # ERROR: test_image_from_directory (tests.tests.TestImageHelpers)
  doCheck = false;
}
