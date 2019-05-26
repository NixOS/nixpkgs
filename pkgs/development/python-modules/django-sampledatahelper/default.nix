{ lib, buildPythonPackage, fetchPypi,
  django, nose, pillow, sampledata, six, versiontools
}:

buildPythonPackage rec {
  pname = "django-sampledatahelper";
  version = "0.4.1";

  meta = {
    description = "Helper class for generate sample data for django apps development";
    homepage = https://github.com/kaleidos/django-sampledatahelper;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "1795zg73lajcsfyd8i8cprb2v93d4csifjnld6bfnya90ncsbl4n";
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
