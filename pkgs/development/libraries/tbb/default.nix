{ lib, stdenv, fetchFromGitHub, fixDarwinDylibNames, compiler ? if stdenv.cc.isClang then "clang" else null, stdver ? null }:

with lib; stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2020_U3";

  src = fetchFromGitHub {
    owner = "01org";
    repo = "tbb";
    rev = version;
    sha256 = "sha256-prO2O5hd+Wz5iA0vfrqmyHFr0Ptzk64so5KpSpvuKmU=";
  };

  nativeBuildInputs = optional stdenv.isDarwin fixDarwinDylibNames;

  makeFlags = optional (compiler != null) "compiler=${compiler}"
    ++ optional (stdver != null) "stdver=${stdver}";

  patches = lib.optional stdenv.hostPlatform.isMusl ./glibc-struct-mallinfo.patch;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp "build/"*release*"/"*${stdenv.hostPlatform.extensions.sharedLibrary}* $out/lib/
    mv include $out/
    rm $out/include/index.html

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
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
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ thoughtpolice dizfer ];
  };
}
