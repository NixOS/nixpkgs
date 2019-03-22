{fetchurl}:

{
  "10".google_apis."armeabi-v7a" = {
    name = "system-image-10-google_apis-armeabi-v7a";
    path = "system-images/android-10/google_apis/armeabi-v7a";
    revision = "10-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-10_r06.zip;
      sha1 = "970abf3a2a9937a43576afd9bb56e4a8191947f8";
    };
  };
  "10".google_apis."x86" = {
    name = "system-image-10-google_apis-x86";
    path = "system-images/android-10/google_apis/x86";
    revision = "10-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-10_r06.zip;
      sha1 = "070a9552e3d358d8e72e8b2042e539e2b7a1b035";
    };
  };
  "15".google_apis."x86" = {
    name = "system-image-15-google_apis-x86";
    path = "system-images/android-15/google_apis/x86";
    revision = "15-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-15_r06.zip;
      sha1 = "a7deb32c12396b6c4fd60ad14a62e19f8bdcae20";
    };
  };
  "15".google_apis."armeabi-v7a" = {
    name = "system-image-15-google_apis-armeabi-v7a";
    path = "system-images/android-15/google_apis/armeabi-v7a";
    revision = "15-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-15_r06.zip;
      sha1 = "6deb76cf34760a6037cb18d89772c9e986d07497";
    };
  };
  "16".google_apis."armeabi-v7a" = {
    name = "system-image-16-google_apis-armeabi-v7a";
    path = "system-images/android-16/google_apis/armeabi-v7a";
    revision = "16-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-16_r06.zip;
      sha1 = "5a5ff097680c6dae473c8719296ce6d7b70edb2d";
    };
  };
  "16".google_apis."x86" = {
    name = "system-image-16-google_apis-x86";
    path = "system-images/android-16/google_apis/x86";
    revision = "16-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-16_r06.zip;
      sha1 = "b57adef2f43dd176b8c02c980c16a796021b2071";
    };
  };
  "17".google_apis."armeabi-v7a" = {
    name = "system-image-17-google_apis-armeabi-v7a";
    path = "system-images/android-17/google_apis/armeabi-v7a";
    revision = "17-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-17_r06.zip;
      sha1 = "a59f26cb5707da97e869a27d87b83477204ac594";
    };
  };
  "17".google_apis."x86" = {
    name = "system-image-17-google_apis-x86";
    path = "system-images/android-17/google_apis/x86";
    revision = "17-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-17_r06.zip;
      sha1 = "7864c34faf0402b8923d8c6e609a5339f74cc8d6";
    };
  };
  "18".google_apis."armeabi-v7a" = {
    name = "system-image-18-google_apis-armeabi-v7a";
    path = "system-images/android-18/google_apis/armeabi-v7a";
    revision = "18-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-18_r06.zip;
      sha1 = "7faaccabbcc5f08e410436d3f63eea42521ea974";
    };
  };
  "18".google_apis."x86" = {
    name = "system-image-18-google_apis-x86";
    path = "system-images/android-18/google_apis/x86";
    revision = "18-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-18_r06.zip;
      sha1 = "dd674d719cad61602702be4b3d98edccfbfea53e";
    };
  };
  "19".google_apis."x86" = {
    name = "system-image-19-google_apis-x86";
    path = "system-images/android-19/google_apis/x86";
    revision = "19-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-19_r37.zip;
      sha1 = "f02473420a166b3df7821d8ae5a623524058b4b8";
    };
  };
  "19".google_apis."armeabi-v7a" = {
    name = "system-image-19-google_apis-armeabi-v7a";
    path = "system-images/android-19/google_apis/armeabi-v7a";
    revision = "19-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-19_r37.zip;
      sha1 = "b388072493ed010fe2ddf607c8c4239f54ce1a0b";
    };
  };
  "21".google_apis."x86" = {
    name = "system-image-21-google_apis-x86";
    path = "system-images/android-21/google_apis/x86";
    revision = "21-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-21_r29.zip;
      sha1 = "1f5ac49e0ae603b0bfeda0c94cd7e0b850b9b50e";
    };
  };
  "21".google_apis."x86_64" = {
    name = "system-image-21-google_apis-x86_64";
    path = "system-images/android-21/google_apis/x86_64";
    revision = "21-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-21_r29.zip;
      sha1 = "74ac387aec286fcee01259dcccd4762cbdb4b517";
    };
  };
  "21".google_apis."armeabi-v7a" = {
    name = "system-image-21-google_apis-armeabi-v7a";
    path = "system-images/android-21/google_apis/armeabi-v7a";
    revision = "21-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-21_r29.zip;
      sha1 = "1d0c428ac7f5eb49c7389ad0beb09f07cb989b45";
    };
  };
  "22".google_apis."x86" = {
    name = "system-image-22-google_apis-x86";
    path = "system-images/android-22/google_apis/x86";
    revision = "22-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-22_r23.zip;
      sha1 = "4ceda9ffd69d5b827a8cc2f56ccac62e72982b33";
    };
  };
  "22".google_apis."armeabi-v7a" = {
    name = "system-image-22-google_apis-armeabi-v7a";
    path = "system-images/android-22/google_apis/armeabi-v7a";
    revision = "22-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-22_r23.zip;
      sha1 = "0a11bdffa6132303baf87e4a531987a74d5f0792";
    };
  };
  "22".google_apis."x86_64" = {
    name = "system-image-22-google_apis-x86_64";
    path = "system-images/android-22/google_apis/x86_64";
    revision = "22-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-22_r23.zip;
      sha1 = "1dfee1c382574c18e3aa2bc2047793169f3ab125";
    };
  };
  "23".google_apis."x86" = {
    name = "system-image-23-google_apis-x86";
    path = "system-images/android-23/google_apis/x86";
    revision = "23-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-23_r30.zip;
      sha1 = "1b8fd61e7e7c76d8c05a41b19370edfb015ed240";
    };
  };
  "23".google_apis."x86_64" = {
    name = "system-image-23-google_apis-x86_64";
    path = "system-images/android-23/google_apis/x86_64";
    revision = "23-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-23_r30.zip;
      sha1 = "69a17c23c4e05e81a2820fe49884807fcebba546";
    };
  };
  "23".google_apis."armeabi-v7a" = {
    name = "system-image-23-google_apis-armeabi-v7a";
    path = "system-images/android-23/google_apis/armeabi-v7a";
    revision = "23-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-23_r30.zip;
      sha1 = "c3966e3a25623a915902d879f90f6d9253dbb619";
    };
  };
  "24".google_apis."x86" = {
    name = "system-image-24-google_apis-x86";
    path = "system-images/android-24/google_apis/x86";
    revision = "24-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-24_r24.zip;
      sha1 = "7a1adb4aa13946830763644d014fc9c6cc1f921d";
    };
  };
  "24".google_apis."x86_64" = {
    name = "system-image-24-google_apis-x86_64";
    path = "system-images/android-24/google_apis/x86_64";
    revision = "24-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-24_r24.zip;
      sha1 = "53b26e8868c7cd27dda31c71ee2bcf999d6b9ce2";
    };
  };
  "24".google_apis."armeabi-v7a" = {
    name = "system-image-24-google_apis-armeabi-v7a";
    path = "system-images/android-24/google_apis/armeabi-v7a";
    revision = "24-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-24_r24.zip;
      sha1 = "85068d55673bbf9417db8d70107ceed0952b5a28";
    };
  };
  "24".google_apis."arm64-v8a" = {
    name = "system-image-24-google_apis-arm64-v8a";
    path = "system-images/android-24/google_apis/arm64-v8a";
    revision = "24-google_apis-arm64-v8a";
    displayName = "Google APIs ARM 64 v8a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/arm64-v8a-24_r24.zip;
      sha1 = "93ab33d90fcdbb30ca2e927cd3eea447e933dfd9";
    };
  };
  "25".google_apis."x86" = {
    name = "system-image-25-google_apis-x86";
    path = "system-images/android-25/google_apis/x86";
    revision = "25-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-25_r15.zip;
      sha1 = "5948473077341265a0b21a53a7e0afc2f980187c";
    };
  };
  "25".google_apis."x86_64" = {
    name = "system-image-25-google_apis-x86_64";
    path = "system-images/android-25/google_apis/x86_64";
    revision = "25-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-25_r15.zip;
      sha1 = "5a81fc218a7fe82cc6af01f7fae54a8000900443";
    };
  };
  "25".google_apis."armeabi-v7a" = {
    name = "system-image-25-google_apis-armeabi-v7a";
    path = "system-images/android-25/google_apis/armeabi-v7a";
    revision = "25-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-25_r15.zip;
      sha1 = "813e25f9a5f6d775670ed6c5e67a39bffa1411bf";
    };
  };
  "25".google_apis."arm64-v8a" = {
    name = "system-image-25-google_apis-arm64-v8a";
    path = "system-images/android-25/google_apis/arm64-v8a";
    revision = "25-google_apis-arm64-v8a";
    displayName = "Google APIs ARM 64 v8a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/arm64-v8a-25_r15.zip;
      sha1 = "c3049e32f031140757f71acb5b8f0179e6f27303";
    };
  };
  "26".google_apis."x86" = {
    name = "system-image-26-google_apis-x86";
    path = "system-images/android-26/google_apis/x86";
    revision = "26-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-26_r12.zip;
      sha1 = "167c83bcfd87127c7376ce986b34701f74fe87ff";
    };
  };
  "26".google_apis."x86_64" = {
    name = "system-image-26-google_apis-x86_64";
    path = "system-images/android-26/google_apis/x86_64";
    revision = "26-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-26_r12.zip;
      sha1 = "fcd46121c3486e2a759d0707c015e0b12bbab9db";
    };
  };
  "27".google_apis."x86" = {
    name = "system-image-27-google_apis-x86";
    path = "system-images/android-27/google_apis/x86";
    revision = "27-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-27_r08.zip;
      sha1 = "623ee2638713b7dfde8044c91280c2afad5a1ade";
    };
  };
  "28".google_apis."x86" = {
    name = "system-image-28-google_apis-x86";
    path = "system-images/android-28/google_apis/x86";
    revision = "28-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-28_r08.zip;
      sha1 = "41e3b854d7987a3d8b7500631dae1f1d32d3db4e";
    };
  };
  "28".google_apis."x86_64" = {
    name = "system-image-28-google_apis-x86_64";
    path = "system-images/android-28/google_apis/x86_64";
    revision = "28-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-28_r08.zip;
      sha1 = "d8901fdfab7410a4c2fa492dd3ce528e4dbcdfd6";
    };
  };
  "Q".google_apis."x86" = {
    name = "system-image-Q-google_apis-x86";
    path = "system-images/android-Q/google_apis/x86";
    revision = "Q-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-Q_r01.zip;
      sha1 = "11233b66b891ce7b3e8e26eaef2f2e35e80d401b";
    };
  };
  "Q".google_apis."x86_64" = {
    name = "system-image-Q-google_apis-x86_64";
    path = "system-images/android-Q/google_apis/x86_64";
    revision = "Q-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-Q_r01.zip;
      sha1 = "fa3578811a52cadf2535da7b64d0a67889c8edb3";
    };
  };
}