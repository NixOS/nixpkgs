{ fetchMaven }:

rec {
  classworlds_1_1 = map (obj: fetchMaven {
    version = "1.1";
    baseName = "classworlds";
    package = "/classworlds";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "202zfp93ly15q5iamjwy2vsrip8i87pmv5pqyxl9v7wvcmd4flyhlhkkx7hw9jy82dbzglrs2jklsm96dy22nv1njm5dw5kbzarhakq"; }
    { type = "jar"; sha512 = "1cs8v7hhbgwfmlx4dm7r78mki5vk0gjn798qy4w1qzkz90hf9yl52srpjair2fg96qsmk22nd73r92vdmjji65l75ji3kfghzx9872x"; }
  ];
}
