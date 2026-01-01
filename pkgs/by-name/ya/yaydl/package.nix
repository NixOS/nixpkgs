{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  openssl,
  ffmpeg,
}:

rustPlatform.buildRustPackage rec {
  pname = "yaydl";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.18.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dertuxmalwieder";
    repo = "yaydl";
    rev = "release-${version}";
<<<<<<< HEAD
    sha256 = "sha256-X5D4kC5P5qHLSlTa9sQUAql1zK+Iut24224wvqihfAY=";
  };

  cargoHash = "sha256-nt9S9KrHO8Vp75XZMQ0RAiALpdQ5LxI2Yaf3LRQD+fE=";
=======
    sha256 = "sha256-blnDixttkmArDQUR6r5PAqa417uh8hmFi8mia/Z0zBA=";
  };

  cargoHash = "sha256-7thGKPBMjkC06n8qyIfx/edFaBx8VS6FUqnf7dowtWk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ openssl ];

  postInstall = ''
    wrapProgram $out/bin/yaydl \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://code.rosaelefanten.org/yaydl";
    description = "Yet another youtube down loader";
    license = lib.licenses.cddl;
=======
  meta = with lib; {
    homepage = "https://code.rosaelefanten.org/yaydl";
    description = "Yet another youtube down loader";
    license = licenses.cddl;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "yaydl";
  };
}
