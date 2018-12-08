{ stdenv
, buildPythonPackage
, fetchFromGitHub
, neovim
, click
, pygobject3
, isPy27
, pkgs
}:

buildPythonPackage rec {
  pname = "neovim-pygui";
  version = "0.1.3";
  disabled = !isPy27;

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "python-gui";
    rev = version;
    sha256 = "1vpvr3zm3f9sxg1z1cl7f7gi8v1xksjdvxj62qnw65aqj3zqxnkz";
  };

  propagatedBuildInputs = [ neovim click pygobject3 pkgs.gobject-introspection pkgs.makeWrapper pkgs.gtk3 ];

  patchPhase = ''
    sed -i -e "s|entry_points=entry_points,|entry_points=dict(console_scripts=['pynvim=neovim.ui.cli:main [GUI]']),|" setup.py
  '';

  postInstall = ''
    wrapProgram $out/bin/pynvim \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix PYTHONPATH : "${pygobject3}/lib/python2.7/site-packages:$PYTHONPATH"
  '';

}
