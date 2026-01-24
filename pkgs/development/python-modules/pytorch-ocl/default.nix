{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  torch,
  ocl-icd,
  opencl-clhpp,
  sqlite,
  python,
}:
buildPythonPackage rec {
  pname = "pytorch-ocl";
  version = "0.2.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "artyom-beilis";
    repo = "pytorch_dlprim";
    rev = "${version}";
    hash = "sha256-N0NjpRWFAYeh2GQu8PPTtf4ZG2Jp9fgttjCbWOYQOmg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  dependencies = [
    torch
    ocl-icd
    opencl-clhpp
    sqlite
  ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;

  postInstall = ''
    mkdir -p $out/${python.sitePackages}
    mv $out/python/* $out/${python.sitePackages}
    rmdir $out/python
  '';

  pythonImportsCheck = [
    "pytorch_ocl"
  ];

  meta = with lib; {
    description = "DLPrimitives/OpenCL out of tree backend for pytorch";
    maintainers = with maintainers; [ gm6k ];
    license = licenses.mit;
    homepage = "https://github.com/artyom-beilis/pytorch_dlprim";
    changelog = "https://github.com/artyom-beilis/pytorch_dlprim/releases/tag/${src.rev}";
  };
}
