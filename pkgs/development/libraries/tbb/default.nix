{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2021.7.0";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "v${version}";
    sha256 = "sha256-Lawhms0yq5p8BrQXMy6dPe29dpSlHdSntum+6bAkpyo=";
  };

  nativeBuildInputs = [ cmake pkg-config ] ++ (lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ]);

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = licenses.asl20;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice dizfer ];
  };
}
