{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  loop-rate-limiters,
  numpy,
  pinocchio,
  qpsolvers,
  typing-extensions,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "pin-pink";
  version = "4.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stephane-caron";
    repo = "pink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XioGci++GEFEJNFPh8ZzLK8Y+CUKAmARAzbILD9fFng=";
  };

  # pinocchio does not install pypa metadata for now
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail \
      '"pin >=' \
      '#"pin >='
  '';

  build-system = [
    flit-core
  ];

  dependencies = [
    loop-rate-limiters
    numpy
    pinocchio
    qpsolvers
    typing-extensions
  ];

  # Need to dowload a lot of data for robot_descriptions
  doCheck = false;

  pythonImportsCheck = [
    "pink"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python inverse kinematics using Pinocchio and QP solvers";
    homepage = "https://github.com/stephane-caron/pink";
    changelog = "https://github.com/stephane-caron/pink/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
