{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  setuptools,
  cython_0,
  cmake,
  numpy,
  oldest-supported-numpy,
  six,
  tqdm,
}:

let
  dic-dirname = "open_jtalk_dic_utf_8-1.11";
  dic-src = fetchzip {
    url = "https://github.com/r9y9/open_jtalk/releases/download/v1.11.1/${dic-dirname}.tar.gz";
    hash = "sha256-+6cHKujNEzmJbpN9Uan6kZKsPdwxRRzT3ZazDnCNi3s=";
  };
in
buildPythonPackage {
  pname = "pyopenjtalk";
  version = "0-unstable-2023-09-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "pyopenjtalk";
    rev = "b35fc89fe42948a28e33aed886ea145a51113f88";
    hash = "sha256-DbZkCMdirI6wSRUQSJrkojyjGmViqGeQPO0kSKiw2gE=";
    fetchSubmodules = true;
  };

  patches = [
    # this patch fixes the darwin build
    # open_jtalk uses mecab, which uses the register keyword and std::binary_function, which are not allowed in c++17
    # this patch removes them
    ./mecab-remove-deprecated.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
        --replace-fail 'setuptools<v60.0' 'setuptools'
  '';

  build-system = [
    setuptools
    cython_0
    cmake
    numpy
    oldest-supported-numpy
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    setuptools # imports pkg_resources at runtime
    numpy
    six
    tqdm
  ];

  postInstall = ''
    ln -s ${dic-src} $out/${python.sitePackages}/pyopenjtalk/${dic-dirname}
  '';

  meta = {
    description = "VOICEVOX's fork of the pyopenjtalk text-to-speech library";
    homepage = "https://github.com/VOICEVOX/pyopenjtalk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
