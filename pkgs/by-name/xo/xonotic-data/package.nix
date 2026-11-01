{
  fetchzip,
  xonotic,
}:

fetchzip {
  name = "xonotic-data";
  url = "https://dl.xonotic.org/xonotic-${xonotic.version}.zip";
  hash = "sha256-Lhjpyk7idmfQAVn4YUb7diGyyKZQBfwNXxk2zMOqiZQ=";
  postFetch = ''
    cd $out
    rm -rf $(ls | grep -v "^data$" | grep -v "^key_0.d0pk$")
  '';
  meta.hydraPlatforms = [ ];
  inherit (xonotic) version;
  pname = "xonotic";
}
