{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation (rec {
  pname = "rnnoise";
  version = "2019-04-24";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "rnnoise";
    rev = "9acc1e5a633e0961a5895a73204df24744f199b6";
    sha256 = "17xip4z0skpzas7wrdyi87j46mbz9jncpj554m8654bqpkxis0pr";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    install -Dt $out/bin examples/.libs/rnnoise_demo
  '';

  meta = with lib; {
    homepage = https://people.xiph.org/~jm/demo/rnnoise/;
    description = "Recurrent neural network for audio noise reduction";
    license = licenses.bsd3;
    maintainers = [ maintainers.nh2 ];
    platforms = platforms.all;
  };
})
