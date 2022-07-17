{ callPackage
, lib
, stdenv
, fetchurl
, nixos
, testers
, hello
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gotrue";
  version = "2.8.0";

  src = fetchurl {
    url = "https://github.com/supabase/gotrue/releases/download/v${finalAttrs.version}/gotrue-v${finalAttrs.version}-arm64.tar.gz";
    sha256 = "01rsiz20wc8zvw280p7f18hl5h3nhvkd59cklfxnlccqzp924rs4";
  };

  doCheck = true;

  passthru.tests = {
    version = testers.testVersion { package = hello; };

    invariant-under-noXlibs =
      testers.testEqualDerivation
        "hello must not be rebuilt when environment.noXlibs is set."
        hello
        (nixos { environment.noXlibs = true; }).pkgs.hello;
  };

  passthru.tests.run = callPackage ./test.nix { hello = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "Standalone Authentication service written in Go";
    longDescription = "GoTrue is a small open-source API written in golang, that can act as a self-standing API service for handling user registration and authentication for JAM projects.";
    homepage = "https://github.com/supabase/gotrue";
    changelog = "https://github.com/supabase/gotrue/releases";
    license = licenses.mit;
    maintainers = [ maintainers.j0 ];
    platforms = platforms.all;
  };
})
