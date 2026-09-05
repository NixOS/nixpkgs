{ fetchFromGitHub, fetchurl }:

{
  # Versions mirror the sources used by platforms/linux-x64/external.sh.
  sdl = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL";
    rev = "8e37db5e797b6167f3a00d697d816a684bd259c7";
    hash = "sha256-6Dph2eLiJUmpQzPWe8EuY5LrWhrFwde2f2dwfgCcWNw=";
  };

  sdl-image = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_image";
    rev = "96a73a551a857b7c8d0ca3cc553a266eabbab6a7";
    hash = "sha256-LNEbXhUDB6OKk3HxwV+jANnskS82ewhQe8pDy+P6L40=";
  };

  sdl-ttf = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_ttf";
    rev = "a1ce3670aec736ecbf0936c43f2f0cc53aa61e5b";
    hash = "sha256-g7LfLxs7yr7bezQWPWn8arNuPxCfYLCO4kzXmLRUUSY=";
  };

  freeimage = fetchFromGitHub {
    owner = "toxieainc";
    repo = "freeimage";
    rev = "b1613452a0c3849d43ac877b154cf51ff9e078d3";
    hash = "sha256-3dd5uEkcrK4mLZT58ZhZaTYzvSI4QBsSflcR4dBzz5g=";
  };

  bgfx-cmake = fetchurl {
    url = "https://github.com/bkaradzic/bgfx.cmake/releases/download/v1.143.9262-545/bgfx.cmake.v1.143.9262-545.tar.gz";
    hash = "sha256-t4u6ZuH6soUc8HJr/AMQBHXLJQWOXpfwv6EAvPA2+y4=";
  };

  bgfx = fetchFromGitHub {
    owner = "vbousquet";
    repo = "bgfx";
    rev = "66fbca4dfe93da62b0f145bec872ee96df326afa";
    hash = "sha256-2h7ZBO7rV/ra6fryqxEfrB3k/nWr6yu8wk+hPuKXxMk=";
  };

  pinmame = fetchFromGitHub {
    owner = "vbousquet";
    repo = "pinmame";
    rev = "8b143198c4f07645db39a4cb4cf7f332702673d0";
    hash = "sha256-UfEIechtJBFHExM+HGXW9Phxqdl0IhN9jdJlriBreOM=";
  };

  libdmdutil = fetchFromGitHub {
    owner = "vpinball";
    repo = "libdmdutil";
    rev = "5879c321e75c2ca3c5dd9cde5d7c49f0075d1f16";
    hash = "sha256-NkcC90DmExmK1sgIOZFyCBTqYrxx3GpSGdzEPXd+TiA=";
  };

  libdmdutil-libzedmd = fetchFromGitHub {
    owner = "PPUC";
    repo = "libzedmd";
    rev = "5c44646f2af4b1419b4cdcaed3a2799ca9439221";
    hash = "sha256-8oU7LzMcnVBff+35nfgUogsW9pag4VOGPpAXbhoBib4=";
  };

  libdmdutil-libserum = fetchFromGitHub {
    owner = "PPUC";
    repo = "libserum";
    rev = "21b28325c4272724e719ab2d17481d851eaf9fd8";
    hash = "sha256-Vf18gnz6sTHU5VM+mOY9ktR/auE5vSBap4fmTBjvN1Y=";
  };

  libdmdutil-libpupdmd = fetchFromGitHub {
    owner = "PPUC";
    repo = "libpupdmd";
    rev = "4a1123220e6dce73c87cc584494df2ac82cb6f4c";
    hash = "sha256-HGRODeS/dhtjTu0b5Ufbs0qxLmTbHOxxeTv0+RiIrvM=";
  };

  libdmdutil-libvni = fetchFromGitHub {
    owner = "PPUC";
    repo = "libvni";
    rev = "7258e2fa0d086e1224d6510d44a61879e6b344b1";
    hash = "sha256-pC5tmLVuXvyOJO5hLXpcEtVbMEYt/s6MiY9o65CRu1E=";
  };

  libdmdutil-cargs = fetchFromGitHub {
    owner = "likle";
    repo = "cargs";
    rev = "0698c3f90333446d0fc2745c1e9ce10dd4a9497a";
    hash = "sha256-DpUeKFVtbpD2lqW10q91zCFmm4AQKAYSHXUp5B1YNM8=";
  };

  libdmdutil-libframeutil = fetchFromGitHub {
    owner = "ppuc";
    repo = "libframeutil";
    rev = "28f2bae0dabcbd5c599e6f62211f009e078c1f96";
    hash = "sha256-Bk8pnSCtB7R157+gLHhnE4eM8UwN0JmD4o44aTiQTNw=";
  };

  libdmdutil-sockpp = fetchFromGitHub {
    owner = "fpagliughi";
    repo = "sockpp";
    rev = "e6c4688a576d95f42dd7628cefe68092f6c5cd0f";
    hash = "sha256-eIgYam/iQXjT3/Fu6ptNGSUVutLMG5Z1tmLsKLFOD/Q=";
  };

  libaltsound = fetchFromGitHub {
    owner = "vpinball";
    repo = "libaltsound";
    rev = "f4b790a19ae45a9f93ae0051df6933800c7a6446";
    hash = "sha256-Y4VxGeLi3GTPWuN0nXUtMQG/1hm2Hpkm4X9Y8HrageM=";
  };

  libdof = fetchFromGitHub {
    owner = "vpinball";
    repo = "libdof";
    rev = "50af22e1909132993c5106cc64a6834710212da0";
    hash = "sha256-vDeQa7BDGae0yL6eNjgy0Z92lubJDpvLgO6nV9gF91g=";
  };

  libdof-libusb = fetchFromGitHub {
    owner = "libusb";
    repo = "libusb";
    rev = "15a7ebb4d426c5ce196684347d2b7cafad862626";
    hash = "sha256-m1w+uF8+2WCn72LvoaGUYa+R0PyXHtFFONQjdRfImYY=";
  };

  libdof-libserialport = fetchFromGitHub {
    owner = "sigrokproject";
    repo = "libserialport";
    rev = "21b3dfe5f68c205be4086469335fd2fc2ce11ed2";
    hash = "sha256-zxHCJTC12kkbKB3UCTblNbNZZRhTuyhC9MR5iVXqYWc=";
  };

  libdof-hidapi = fetchFromGitHub {
    owner = "libusb";
    repo = "hidapi";
    rev = "d6b2a974608dec3b76fb1e36c189f22b9cf3650c";
    hash = "sha256-o6IZRG42kTa7EQib9eaV1HGyjaGgeCabk+8fyQTm/0s=";
  };

  libdof-libftdi = fetchFromGitHub {
    owner = "jsm174";
    repo = "libftdi";
    rev = "5c2c58e03ea999534e8cb64906c8ae8b15536c30";
    hash = "sha256-RmD40HVsx1fyBwHkYPmG+FZBfPcOGj87lH+tCfx4N24=";
  };

  ffmpeg = fetchFromGitHub {
    owner = "FFmpeg";
    repo = "FFmpeg";
    rev = "239f2c733de417201d7ad3b3b8b0d9b63285b2b1";
    hash = "sha256-WPGfjTZjsgpR5QiANRWF4g6LF2ejGzFQUrLjhzw9cfQ=";
  };

  libzip = fetchFromGitHub {
    owner = "nih-at";
    repo = "libzip";
    rev = "6f8a0cdd24a0dc6cce9dac4a7679da784ab124ea";
    hash = "sha256-+ekbD3PWAGhBJGIqqa9AnWcG7hToeFPRr6kkmxJHOaY=";
  };

  libwinevbs = fetchFromGitHub {
    owner = "vpinball";
    repo = "libwinevbs";
    rev = "8ce73e202a4971ad3e08d91c694ea7ca0fe81ed6";
    hash = "sha256-3kGx35IAICIgS0D1I5UTrDxfC1lrwPaSWwBOydFCy9E=";
  };
}
