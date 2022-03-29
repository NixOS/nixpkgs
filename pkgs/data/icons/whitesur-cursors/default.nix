{ fetchFromGitHub, lib }:

fetchFromGitHub {
  owner = "vinceliuice";
  repo = "WhiteSur-cursors";
  rev = "5c94e8c22de067282f4cf6d782afd7b75cdd08c8";
  hash = "sha256-/eUH6EIWqzwUgHw1ZV8mws9Kip7W4t8RkInd0K22Nv4=";

  extraPostFetch = ''
    shopt -s extglob
    mkdir -p $out/share/icons
    cp -r $out/dist $out/share/icons/WhiteSur-cursors
    rm -rf $out/!(share)
  '';

  meta = with lib; {
    description = "WhiteSur cursors theme for linux desktops";
    homepage = "https://github.com/vinceliuice/WhiteSur-cursors";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sei40kr ];
  };
}
