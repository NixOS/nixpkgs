{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  setuptools,
  wheel,

  grpcio,
  grpcio-tools,

  unittestCheckHook,
}:

let
  version = "2.19.0";
  # update with package
  commonProtosSrc = fetchFromGitHub {
    owner = "nvidia-riva";
    repo = "common";
    rev = "aca81234f8cd62898463742849738bf07a0d4dbb";
    hash = "sha256-7UylSj6jZuk9RitTtb6iTfdpvQWkTskIm5gBpD2wLaY=";
  };
in
buildPythonPackage {
  pname = "nvidia-riva-client";
  inherit version;
  disabled = pythonOlder "3.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nvidia-riva";
    repo = "python-clients";
    tag = "r${version}";
    hash = "sha256-tDZoiHRzmqM6W6Q8FowmvNwWBJWQjwcLL0WEnUbnBDE=";
  };

  postPatch = ''
    rm -rf common
    ln -s ${commonProtosSrc} ./common
  '';

  build-system = [ setuptools ];

  dependencies = [
    grpcio
    grpcio-tools
  ];

  # there is a tests dir but seemingly unused right now

  pythonImportsCheck = [ "riva" ];

  meta = {
    description = "Riva Python client API and CLI utils";
    homepage = "https://github.com/nvidia-riva/python-clients";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
