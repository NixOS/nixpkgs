{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  fontconfig,

  # nativeBuildInputs
  cmake,
  doxygen,
  graphviz,
  scipy,

  # buildInputs
  boost,

  # propagatedBuildInputs
  eigen,
  jrl-cmakemodules,
  numpy,

}:

buildPythonPackage rec {
  pname = "eigenpy";
  version = "3.12.0";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "eigenpy";
    tag = "v${version}";
    hash = "sha256-U4uL0knGJFpD14Gc32lgTZlw7QlXHMEqTnp0bmHJRU8=";
  };

  outputs = [
    "dev"
    "doc"
    "out"
  ];

  cmakeFlags = [
    "-DINSTALL_DOCUMENTATION=ON"
    "-DBUILD_TESTING=ON"
    "-DBUILD_TESTING_SCIPY=ON"
  ];

  strictDeps = true;

  # Fontconfig error: No writable cache directories
  preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    scipy
  ];

  buildInputs = [ boost ];

  propagatedBuildInputs = [
    eigen
    jrl-cmakemodules
    numpy
  ];

  preInstallCheck = "make test";

  pythonImportsCheck = [ "eigenpy" ];

  meta = with lib; {
    description = "Bindings between Numpy and Eigen using Boost.Python";
    homepage = "https://github.com/stack-of-tasks/eigenpy";
    changelog = "https://github.com/stack-of-tasks/eigenpy/releases/tag/${src.tag}";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      nim65s
      wegank
    ];
    platforms = platforms.unix;
  };
}
