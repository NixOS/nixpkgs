{
  lib,

  buildPythonPackage,
  fetchFromGitHub,
  fontconfig,

  # nativeBuildInputs
  scipy,

  # buildInputs
  boost,
  jrl-cmakemodules,

  # propagatedBuildInputs
  eigen,
  numpy,
}:

buildPythonPackage rec {
  pname = "eigenpy";
  version = "3.13.0";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "eigenpy";
    tag = "v${version}";
    hash = "sha256-05G0U1RjVwggfnABxZH+9kxDIo7M9rgxHCcTvNgTZCQ=";
  };

  outputs = [
    "dev"
    "doc"
    "out"
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    "-DINSTALL_DOCUMENTATION=ON"
    "-DBUILD_TESTING=ON"
    "-DBUILD_TESTING_SCIPY=ON"
  ];

  strictDeps = true;

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    scipy
  ];

  buildInputs = [
    boost
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    eigen
    numpy
  ];

  preInstallCheck = ''
    make test
  '';

  pythonImportsCheck = [ "eigenpy" ];

  meta = {
    description = "Bindings between Numpy and Eigen using Boost.Python";
    homepage = "https://github.com/stack-of-tasks/eigenpy";
    changelog = "https://github.com/stack-of-tasks/eigenpy/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix;
  };
}
