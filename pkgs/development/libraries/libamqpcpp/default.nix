{ lib, stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "libamqpcpp";
<<<<<<< HEAD
  version = "4.3.26";
=======
  version = "4.3.24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "CopernicaMarketingSoftware";
    repo = "AMQP-CPP";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-lHkYoppJ/wo6RRE6V4iN6JXz5OoErJUl4IyrwiCB9FM=";
=======
    sha256 = "sha256-65/LsH1ZDkeBrtQUmKc5/5C2ce4nw4nSHXnJqZMKenI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ openssl ];

  patches = [ ./libamqpcpp-darwin.patch ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Library for communicating with a RabbitMQ server";
    homepage = "https://github.com/CopernicaMarketingSoftware/AMQP-CPP";
    license = licenses.asl20;
    maintainers = [ maintainers.mjp ];
    platforms = platforms.all;
  };
}
