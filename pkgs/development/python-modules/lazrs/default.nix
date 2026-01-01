{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "lazrs";
<<<<<<< HEAD
  version = "0.8.1";
=======
  version = "0.8.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-K+LUgba6PkgxlQEvenrr7niY6GiKaWRIvzki7wx8L0E=";
=======
    hash = "sha256-Ij6nRxQO83TJysnLImqg/FuyWYj8ITiiTUFSuoGd044=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-bMQl1URU4VnRPyw8WdZkZlBv3qldv+vpwd+ZxqPZ/JI=";
=======
    hash = "sha256-9OQKybY6R1yYWgx5cLcRv2pRRWKUhrKH+MoTBuBHH6E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonImportsCheck = [ "lazrs" ];

  meta = {
    description = "Python bindings for laz-rs";
    homepage = "https://github.com/laz-rs/laz-rs-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nh2
      chpatrick
    ];
    teams = [ lib.teams.geospatial ];
  };
}
