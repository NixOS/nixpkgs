{ lib
, buildPythonPackage
, fetchFromGitHub
, tabulate
, absl-py
, jmp
, optax
}:

buildPythonPackage rec {
  pname = "dm-haiku";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ihMh0mHz1dsDthV3BAMjLZL0EUdqPTvMji1UoCaTuNU=";
  };

  propagatedBuildInputs = [
    tabulate
    absl-py
    jmp
    optax
  ];

  # Tests require huge dependencies (tensorflow for one)
  doCheck = false;

  pythonImportsCheck = [ "haiku" ];

  meta = with lib; {
    description = "JAX-based neural network library";
    homepage = "https://dm-haiku.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ harwiltz ];
  };
}
