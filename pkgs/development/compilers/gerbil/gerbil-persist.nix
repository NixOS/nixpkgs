{
  lib,
  fetchFromGitHub,
  gerbilPackages,
  ...
}:
{
  pname = "gerbil-persist";
  version = "unstable-2023-11-29";
  git-version = "0.2-6-g8a5e40d";
  softwareName = "Gerbil-persist";
  gerbil-package = "clan/persist";
  version-path = "version";

  gerbilInputs = with gerbilPackages; [
    gerbil-utils
    gerbil-crypto
    gerbil-poo
    gerbil-leveldb
  ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-persist";
    rev = "8a5e40deb01140b9c8d03c6cc985e47a9d7123d8";
    sha256 = "1c1h1yp7gf23r3asxppgga4j4jmy4l9rlbb7vw9jcwvl8d30yrab";
  };

  meta = with lib; {
    description = "Gerbil Persist: Persistent data and activities";
    homepage = "https://github.com/fare/gerbil-persist";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
