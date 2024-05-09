{ lib
, rustPlatform
, fetchFromSourcehut
}:

rustPlatform.buildRustPackage rec {
  pname = "wayidle";
  version = "0.1.1";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "wayidle";
    rev = "v${version}";
    hash = "sha256-6wULrwGnXLdrX/THanJThbykKjNKpGukw9dj0jX0/dM=";
  };

  cargoHash = "sha256-zF2s3XSXnN7jVtv/0axzHiIJd/cb6wMYAOQILXp1U5U=";

  meta = with lib; {
    description = "Execute a program when a Wayland compositor reports being N seconds idle";
    homepage = "https://git.sr.ht/~whynothugo/wayidle";
    license = licenses.isc;
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "wayidle";
    platforms = platforms.linux;
  };
}
