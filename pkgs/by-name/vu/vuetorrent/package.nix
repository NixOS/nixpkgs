{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "vuetorrent";
<<<<<<< HEAD
  version = "2.31.1";
=======
  version = "2.30.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "VueTorrent";
    repo = "VueTorrent";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-og+pmqs91wGkb4cFUbgqPInvNKw7WJuXBznt4BoWYZQ=";
  };

  npmDepsHash = "sha256-DKoOqOd7y8dfCGARlrB2kiOpMo3g1inMqfCTufWIJOI=";
=======
    hash = "sha256-sek5kiO1T7s+PIIa0mBGj+9CfF56eRB3En9tsOcEK5Y=";
  };

  npmDepsHash = "sha256-vEgwEYVlyTJLOQ8j6hm1O4iTIXNPDZyrmvXyRBgEvQY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r vuetorrent $out/share/vuetorrent

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Full-featured BitTorrent client written in Vue";
    homepage = "https://github.com/VueTorrent/VueTorrent";
    changelog = "https://github.com/VueTorrent/VueTorrent/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ redxtech ];
  };
}
