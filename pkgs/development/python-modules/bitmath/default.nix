{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  progressbar231 ? null,
  progressbar33,
  mock,
}:

buildPythonPackage rec {
  pname = "bitmath";
  version = "1.4.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fmSh5xYYh+JU27kQlC4mX+hApM8M7eTimh2pdUtzNOg=";
  };

  nativeCheckInputs = [
    (if isPy3k then progressbar33 else progressbar231)
    mock
  ];

  meta = {
    description = "Module for representing and manipulating file sizes with different prefix";
    mainProgram = "bitmath";
    homepage = "https://github.com/tbielawa/bitmath";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twey ];
  };
}
