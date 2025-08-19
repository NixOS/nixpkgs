{
  x86_64-linux = {
    platform = "manylinux1_x86_64";
    cpu = {
      cp312 = "sha256-gafFsQFQsHUh0c0Ukdyh+3b/YhsU2xDomdlZ86d5Neo=";
      cp313 = "sha256-j8SGXv02Vu6ZQkEkeSy4imQhUbTVkafW1KXGr9rpWVk=";
    };
    gpu = {
      cp311 = "sha256-KWlGhjg9k1+wlm3Tk/mvMqh9LWZ0yGA1g99bCPlFf0U=";
      cp312 = "sha256-KJ2drJWLuwdaYsCj7egh1nQV4j35vT+UgH0qTdxoyHk=";
    };
  };
  aarch64-linux = {
    platform = "manylinux2014_aarch64";
    cpu = {
      cp312 = "sha256-3aqZaosKANvkJp2iHWUFKHfsNpOiLswHucraPs0RaIY=";
      cp313 = "sha256-u8TVc7NdJKJi4C1yaW6A9bSu5B9phnGvlXTe6xqD5vc=";
    };
  };
  x86_64-darwin = {
    platform = "macosx_10_9_x86_64";
    cpu = {
      cp312 = "sha256-3P6/sQ3rFaoz0qLWbVoS2d5lRh2KQNJofi+zIhFQ0Lo=";
      cp313 = "sha256-UsQB/+Sq5WMWZgozAVpv11XNoj09cKKLE7c9cMvbuMs=";
    };
  };
  aarch64-darwin = {
    platform = "macosx_11_0_arm64";
    cpu = {
      cp312 = "sha256-hnfo1C/2b3T7yjL/Mti2S749Vu0pqS1D3EGPDxaPy2k=";
      cp313 = "sha256-nRBR8uII2h1Dna7nyGG8tQJA8JcSSW62Hpzoxhj68vk=";
    };
  };
}
