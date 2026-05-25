{
  lib,
  symlinkJoin,
  television,
  makeBinaryWrapper,
  extraPackages,
}:

symlinkJoin {
  inherit (television) version;
  pname = "${television.pname}-with-pkgs";

  paths = [ television ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram $out/bin/tv \
      --prefix PATH : "${lib.makeBinPath extraPackages}"
  '';

  meta = {
    inherit (television.meta)
      description
      longDescription
      homepage
      changelog
      license
      mainProgram
      maintainers
      ;
  };
}
