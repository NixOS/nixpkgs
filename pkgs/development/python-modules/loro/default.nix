{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "loro";
<<<<<<< HEAD
  version = "1.10.3";
=======
  version = "1.8.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-aBhKscKrlK9q1Kq6QW0i9XnKvuCybLsJofZ4WCB7vOg=";
=======
    hash = "sha256-0i3BfL7GUu2L9if4AaCjLieoe0R2oquW9FoC0WPXM64=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-Lp4VwxmYqB2uvCuxX+tHl0QCpbCvPMjgrgPk0KL1LEQ=";
=======
    hash = "sha256-pJJiwLHh10G9L+NZhxcCif2OP1cpjyNCaeG28YyYxmM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Data collaborative and version-controlled JSON with CRDTs";
    homepage = "https://github.com/loro-dev/loro-py";
    changelog = "https://github.com/loro-dev/loro-py/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmadisetti
    ];
  };
}
