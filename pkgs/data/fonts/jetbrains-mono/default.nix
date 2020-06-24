{ lib, fetchzip, mkFont }:

mkFont rec {
  pname = "JetBrainsMono";
  version = "1.0.6";

  src = fetchzip {
    url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";
    sha256 = "1jgbc9v5j3kcbzbwgkh7pzvb99g8j0v61hbm5306a9r8xv8l0yky";
  };

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
