{ lib
, buildPythonPackage
, fetchFromGitHub
, protobuf
, dill
, grpcio
, pulumi
, isPy27
, semver
, pytestCheckHook
, pyyaml
, six
}:
buildPythonPackage rec {
  inherit (pulumi) version src;

  pname = "pulumi";

  disabled = isPy27;

  propagatedBuildInputs = [
    semver
    protobuf
    dill
    grpcio
    pyyaml
    six
  ];

  checkInputs = [
    pulumi.pkgs.pulumi-language-python
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test/"
  ];

  sourceRoot = "${src.name}/sdk/python/lib";

  # we apply the modifications done in the pulumi/sdk/python/Makefile
  # but without the venv code
  postPatch = ''
    cp ../../README.md .
    substituteInPlace setup.py \
      --replace "3.0.0" "${version}" \
      --replace "grpcio==1.50" "grpcio"
  '';

  # Allow local networking in tests on Darwin
  __darwinAllowLocalNetworking = true;

  # Verify that the version substitution works
  preCheck = ''
    pip show "${pname}" | grep "Version: ${version}" > /dev/null \
      || (echo "ERROR: Version substitution seems to be broken"; exit 1)
  '';

  pythonImportsCheck = [ "pulumi" ];

  meta = with lib; {
    description = "Modern Infrastructure as Code. Any cloud, any language";
    homepage = "https://github.com/pulumi/pulumi";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
