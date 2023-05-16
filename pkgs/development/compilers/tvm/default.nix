{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tvm";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-tvm";
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-WG0vU3lxX5FNs0l37mTE1T7rSEEtfTEisE3cMphzeAk=";
=======
    sha256 = "sha256-D6j5KHx7I9UmcI6SSuDMYQE/4ae9ZfDef1bdIzryefk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];
  # TVM CMake build uses some sources in the project's ./src/target/opt/
  # directory which errneously gets mangled by the eager `fixCmakeFiles`
  # function in Nix's CMake setup-hook.sh to ./src/target/var/empty/,
  # which then breaks the build. Toggling this flag instructs Nix to
  # not mangle the legitimate use of the opt/ folder.
  dontFixCmake = true;

  meta = with lib; {
    homepage = "https://tvm.apache.org/";
    description = "An End to End Deep Learning Compiler Stack for CPUs, GPUs and accelerators";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ adelbertc ];
  };
}
