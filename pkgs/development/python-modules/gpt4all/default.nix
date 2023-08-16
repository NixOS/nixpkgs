{ lib
, buildPythonPackage
, cmake
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, shaderc
, stdenv
, tqdm
, vulkan-headers
, vulkan-loader
, vulkan-tools
}:

let
  version = "2.6.1";
  src = fetchFromGitHub {
    owner = "nomic-ai";
    repo = "gpt4all";
    rev = "v${version}";
    hash = "sha256-eU2WgyPn0ZajzA2RYCD1ihUn4yXzE1wi46Z4M3KEQyM=";
    fetchSubmodules = true;
  };

  deps = stdenv.mkDerivation rec {
    inherit src;
    name = "gpt4all-backend";
    sourceRoot = "source/gpt4all-backend";

    nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      shaderc
      vulkan-headers
      vulkan-loader
      vulkan-tools
    ];

    cmakeFlags = [
      "-DKOMPUTE_OPT_USE_BUILT_IN_VULKAN_HEADER=off"
    ];

    installPhase = ''
      mkdir -p $out
      install -m 0644 *.so $out
    '';
  };
in
buildPythonPackage rec {
  inherit src version;

  pname = "gpt4all";
  sourceRoot = "source/gpt4all-bindings/python";
  disabled = pythonOlder "3.8";

  nativeCheckInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    requests
    tqdm
  ];

  # It'd be nice if upstream was aware of this discomfort..
  patches = [ ./disable-copy.patch ];

  postPatch = ''
    mkdir -p gpt4all/llmodel_DO_NOT_MODIFY
    ln -s ${deps} gpt4all/llmodel_DO_NOT_MODIFY/build
  '';

  # the tests download huge model files
  doCheck = false;

  meta = with lib; {
    description = "Python bindings for GPT4All";
    homepage = "https://gpt4all.io";
    license = licenses.zpl21;
    maintainers = with maintainers; [ bbigras ];
  };
}
