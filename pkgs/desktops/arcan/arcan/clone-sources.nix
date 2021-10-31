{ fetchgit, fetchFromGitHub }:
{
  letoram-openal-src = fetchFromGitHub {
    owner = "letoram";
    repo = "openal";
    rev = "1c7302c580964fee9ee9e1d89ff56d24f934bdef";
    hash = "sha256-InqU59J0zvwJ20a7KU54xTM7d76VoOlFbtj7KbFlnTU=";
  };
  freetype-src = fetchgit {
    url = "git://git.sv.nongnu.org/freetype/freetype2.git";
    rev = "94cb3a2eb96b3f17a1a3bd0e6f7da97c0e1d8f57";
    sha256 = "sha256-LzjqunX/T8khF2UjPlPYiQOwMGem8MqPYneR2LdZ5Fg=";
  };
  libuvc-src = fetchgit {
    owner = "libuvc";
    repo = "libuvc";
    rev = "b2b01ae6a2875d05c99eb256bb15815018d6e837";
    sha256 = "sha256-2zCTjyodRARkHM/Q0r4bdEH9LO1Z9xPCnY2xE4KZddA=";
  };
  luajit-src = fetchgit {
    url = "https://luajit.org/git/luajit-2.0.git";
    rev = "d3294fa63b344173db68dd612c6d3801631e28d4";
    sha256 = "sha256-1iHBXcbYhWN4M8g5oH09S1j1WrjYzI6qcRbHsdfpRkk=";
  };
}
