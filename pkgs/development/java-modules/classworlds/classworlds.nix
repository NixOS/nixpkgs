{ fetchMaven }:

rec {
  classworlds_1_1_alpha2 = map (obj: fetchMaven {
    version = "1.1-alpha-2";
    artifactId = "classworlds";
    groupId = "classworlds";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "027b0s13ck41wg75z7bz1zxazdxp56llxlg4z9kp01wys1sbkng8s0i0mxyvjaq61q5lg2gfrxypnzg7vha23vq57hkdhwyksjdcd5c"; }
    { type = "jar"; sha512 = "36vir8jja85cg7khaf2qjln7m8q5iq0n43vvkxkwwngv67ffpvqqz6j1fscvl16hzb0nf6j9gzkcrgk3mk9jl49vrj3fw7c173m4xzb"; }
  ];

  classworlds_1_1 = map (obj: fetchMaven {
    version = "1.1";
    artifactId = "classworlds";
    groupId = "classworlds";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "202zfp93ly15q5iamjwy2vsrip8i87pmv5pqyxl9v7wvcmd4flyhlhkkx7hw9jy82dbzglrs2jklsm96dy22nv1njm5dw5kbzarhakq"; }
    { type = "jar"; sha512 = "1cs8v7hhbgwfmlx4dm7r78mki5vk0gjn798qy4w1qzkz90hf9yl52srpjair2fg96qsmk22nd73r92vdmjji65l75ji3kfghzx9872x"; }
  ];
}
