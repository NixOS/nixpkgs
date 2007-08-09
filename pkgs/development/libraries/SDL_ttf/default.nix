args:
args.stdenv.mkDerivation {
  name = "SDL_image-1.2.6";

  src = args.
	fetchurl {
		url = http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.9.tar.gz;
		sha256 = "0ls6anmlmwrmy21p3y9nfyl6fkwz4jpgh74kw7xd0hwbg5v8h95l";
	};

  buildInputs =(with args; [SDL freetype]);

  postInstall = "ln -s \${out}/include/SDL/SDL_ttf.h \${out}/include/";

  meta = {
    description = "
	SDL image library.
";
  };
}
