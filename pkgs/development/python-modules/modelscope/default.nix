{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  filelock,
  requests,
  tqdm,
}:

let
  version = "1.31.0";
in
buildPythonPackage {
  pname = "modelscope";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelscope";
    repo = "modelscope";
    tag = "v${version}";
    hash = "sha256-3o3iI4LGDSsF36jnrUTN3bBaM8XGCw+msIPS3WauMNQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "exec(compile(f.read(), version_file, 'exec'))" "ns = {}; exec(compile(f.read(), version_file, 'exec'), ns)" \
      --replace-fail "return locals()['__version__']" "return ns['__version__']"
  '';

  build-system = [ setuptools ];

  dependencies = [
    filelock
    requests
    setuptools
    tqdm
  ];

  doCheck = false; # need network

  pythonImportsCheck = [ "modelscope" ];

  meta = {
    description = "Bring the notion of Model-as-a-Service to life";
    homepage = "https://github.com/modelscope/modelscope";
    license = lib.licenses.asl20;
    mainProgram = "modelscope";
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
