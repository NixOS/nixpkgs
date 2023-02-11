{ lib, stdenv, substitute, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libamplsolver";
  version = "20211109";

  src = fetchurl {
    url = "https://ampl.com/netlib/ampl/solvers.tgz";
    sha256 = "sha256-LVmScuIvxmZzywPSBl9T9YcUBJP7UFAa3eWs9r4q3JM=";
  };

  patches = [
    (substitute {
      src = ./libamplsolver-sharedlib.patch;
      replacements = [ "--replace" "@sharedlibext@" "${stdenv.hostPlatform.extensions.sharedLibrary}" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    pushd sys.$(uname -m).$(uname -s)
    install -D -m 0644 *.h -t $out/include
    install -D -m 0644 *${stdenv.hostPlatform.extensions.sharedLibrary}* -t $out/lib
    install -D -m 0644 *.a -t $out/lib
    popd
    runHook postInstall
  '';

  meta = with lib; {
    description = "A library of routines that help solvers work with AMPL";
    homepage = "https://ampl.com/netlib/ampl/";
    license = [ licenses.mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ aanderse ];
  };
}
