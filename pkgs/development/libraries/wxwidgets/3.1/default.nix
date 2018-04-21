{ stdenv, fetchFromGitHub
, wxGTK30
}:

with stdenv.lib;

wxGTK30.overrideAttrs (oldAttrs : rec {
    name = "wxwidgets-${version}";
    version = "3.1.0";
    src = fetchFromGitHub {
        owner = "wxWidgets";
        repo = "wxWidgets";
        rev = "v${version}";
        sha256 = "14kl1rsngm70v3mbyv1mal15iz2b18k97avjx8jn7s81znha1c7f";
    };
})