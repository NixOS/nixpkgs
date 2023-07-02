{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  version = "1.9";
  pname = "fpattern";
  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "Loadmaster";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-/QvMQCmoocaXfDm3/c3IAPyfZqR6d7IiJ9UoFKZTpVI=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out $dev/include
    cp *.c *.h $dev/include
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Loadmaster/fpattern";
    description = "Filename pattern matching library functions for DOS, Windows, and Unix";
    license = licenses.mit;
    maintainers = with maintainers; [ hughobrien ];
    platforms = with platforms; linux;
  };
})
