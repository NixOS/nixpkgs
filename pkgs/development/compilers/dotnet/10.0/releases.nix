{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.9";
      hash = "sha512-9rIxm1MISHBD5kKPYpgiVjGSA6nY6/lDtJ+q6Z2U+4uKPN+mx0Q3xuDQiGz6TWCfU/rv13gH78V6WEqyHjKKfw==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.9";
      hash = "sha512-XpxODbU9n0VVbMS6o/U/rxKD1YepusjNv6vanR9fil1/GMnK7TlReVUu8v2pX6ZRFAUeCnR2vzs8eZrzQrYjXg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.9";
      hash = "sha512-Zu724iO3KztioczUaVIkIf1fYeuyG/YOtuhc23koVT+A7mDYjOlwtF1R24MjGht6YVIW6CcbrC2zB2zsnmu01w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.9";
      hash = "sha512-rWQyRVuTET24XM2aUdxbWPmhRgd5mIypan61IN8BOCfZoQbqP5VX5EjRDcxLwF3RzzIkxTyeh0SbVuGLt93xGw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.9";
      hash = "sha512-FZgt8D+8jUrwmj8+9dffPifGBs5OklPd7ReCQcXLQAfEAyABjQe+xWQtQU8tbZwLfWOrzDISsKQXuJ7VUbagLg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.9";
      hash = "sha512-FeXZfSx/RVXiooaWdkmd9g8TGAKC+MeC5IBByPf2FgTgR+NAXLMTgfHgimM6T4iV40+s2tzFXM/7RKYLZKZjHA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.9";
        hash = "sha512-3Kq1DLXmlncPEZL1Hb/BIFsOg74l97v7MmoArkJH2dVzvkzIxwXkiqe6XDo6QAdIShUx+LZ7sbJ30hop3DI4sA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.9";
        hash = "sha512-eAjWxz37AwAM+IymkxgtQbYRHNCK88jbwXcQUhJoOYQy080h/lHyH+A2O+gu2Wb4+foZqmXcThlsWPrQrk+THg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-29MiMOG0miPFyEbQm9EHeOWamADuOeMoFEItX+xT45xpmY/A1PiO6NwDqPofmM68C02AT85afa7K6V1SU2bgBw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.9";
        hash = "sha512-fNUUigQviEk7mhhouQiyAtUBYHJ9UVZlZCIi78JLOQKoIih5QLmgJqja6oKljm3i1f+Z/y7luIkMSluXYrICnQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-Pzm4bl66t2VJJaWCnAnOuVM5pO2fYo5xNIKiW/XAbaR1iU2VY92LaxmQz9cQvJi5qbJqlklWpVskITiZ9vPcnw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.9";
        hash = "sha512-15ha5nFP74LI0yC3Ok4DqZdDBNGt9YZhkF3yEQeZ0nVLcKEtrmT8KG3ytfdYkJEiPd4Jf0g0M73eFpnSbESMgg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.9";
        hash = "sha512-L8xZFeFa2M0cgqcaaPnI7YwxMDRZQ1GUZGAnnhhVNnjZ84MW2wOhmuk5+mi52hwKt31I6d7c6D/hPbjnTr3wMQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-f8uUgL+ni9FvyQ9otg3UTn3wX3LDy55HKDXzEVaxERu6+CvuCQIHDe+Hs0u0CjfOKhbkGifL+mfele8mPTDHjg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.9";
        hash = "sha512-VP9wmJdKxOngnQ3LHajl9MU6JjHB3aGJOazSvTxNRveJ7TfSh3+GiX6ddS3I4sifnGRdz8+kuGt5a/9NP+EDIQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-3KwnacJWiN8tptsGtKA/W31pvv1caxEUcMB9oss7o3272VSCFvIEYFWfGbW8XZR79q3r0CE45J2xISNpPjYNfQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.9";
        hash = "sha512-jDdX9SxVfU/96Xn9YXXWIBKkOBFYzkToLF6s81PxXP5oqQgkAbT7tvN4sQPBgfM3Vn8+z5oOSYmnGijlBAQHwQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-O/lQAy5vxO1I5DForGqGneP+taWU1BQNEQw/xE8sAVHdSUJTIeYH3Cj4198Bh0eKHvpHpaySoLYJT3lIEvgi3Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.9";
        hash = "sha512-IhxLam7sHBOfcfC9ewSV6nEwn4IxZeUQ2CeTkRgMvKlSR7XyNTe2QPgQ6n/XFnJoaM/kTDI34XWAlp99KgoEOA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-SX39Owpp/L/kKsNkKLkU/V5ylnocuqGLxOpfKKtMj8pybKfrIb6ZZyXcw5hK9b9RXPpvneA5M+d1A0NSiuovhw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.9";
        hash = "sha512-t4JnuHeXkPXb8CXycJ/JTmM0718OzBTgNi/DOlNMM79I8nihMsf600w69vFsYd5Hp9/Ww3bmXoUvIDGfCyxNPA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-1yUVD2vRUUkj779wDxgeQjXl+1PqgWp85Q0mAYzrS1ew0a9EmFGNufJiJRgJtidgh4I4wAnuu9SfAeGdpr3Dnw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.9";
        hash = "sha512-0xGXyM78+EEfXFOVwNfSiN38wj+jHAqdCwGV+2/vKTU2pUZcsOMSxw6UNqRgX152qHshfTcqFmzYfFeulFWV4A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-+1dzYiP2FfMxBPWJOYgyKzggthCyEHF25aOElEmvY52nWigrfOGETvenuB39SNbr6A+Ng9l23ndU7L5EnqCLJQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.9";
        hash = "sha512-6ejTRfg0TJilbm2EZUopngMFb5ddLN1jxtf55qEd4idDyRJEHt7Bj47XxUZgNGEheHVZOZx2kCRUMfncdKoFdg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.9";
        hash = "sha512-I6Qy9ay9FzFz+iPpoU8ec4SEh/qUBsgVQnkXb7YwPNYKLpsf73wox/EUXMC2jCwqNyCwVsm9HQfjsXYWjVTWSw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.9";
        hash = "sha512-JbbOGMymd1uRUoaO9RNqNDNxcO/wfiOG6QwDn8fMtpWI2xd+Oe1b4dNZAci0l6iivjiS+G0n/Q56iBhDC3D/fA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.9";
        hash = "sha512-88zk5JjDJCPyoSLelE3SDUq3IvdzWQWJw21WQxnypIaXuQHEFuMDZ1Ore6i7RMouY9MWuJCEcS03lk0JL1Ah/w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-4CZmtTz42fN9U0q/iqbVA1FvUY5beQobCuK9miMaLpnHD9YacWxWhYvAcYhM1XLR6kuCMVLz/TrhlEpKnvPF1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.9";
        hash = "sha512-QQH/dX5LYmrbLcLynAvC0H7MvsWAR1ay5yjtAI5M/PUPsPiTyC60I/tVCdyQYXjPKgM4FJWWRsdvgo1gp/kBYw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.9";
        hash = "sha512-kJiXbxRjkAjazH+ctmkM4WysXgpMR99Ps2hN2oI8WOJ9kkA700BLmNS2mAlNoAVrRGFOfgkrQ7m/XeCj3Xx4ew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.9";
        hash = "sha512-euGxy2l/aSt5wbImQKDgUJDjSko+4+oJPKa3oQkXfw4q2TF5BA1lFU7f8zNSFb1XMUU4oXJ44JkPR0+pH8WZdA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.9";
        hash = "sha512-KKHaaWDeoezXsj1BeLwxM69GZKE6aFwv81N966STiG2RjkCKb1EMevUk77k0inrgtUDEWYZGdEiZyeS7mK68Tg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-kD14znP6p0rGZ7q0/2lHwyAHoWXQtxUc1hDVpixrV9fSIEkJYcn8LvsXNNlGbGZAq0a+nTegFLXBJSTTMw5+Gg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.9";
        hash = "sha512-+ejx2iYt0FngjKQMSkowwAyuO5F2ucim+VL75/oHuuU2Q4XZDWoyBvx566XXbctUF76eNFAWWu8CefYFw+LXKA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.9";
        hash = "sha512-o7SZ4gPlt0o+A4RnNRCjWM1zonHw5fJDr9wHT0qHyUD+56vkztBh9WG3+Sv3Xexrq7lzNquNcQutQgICPM8Z7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.9";
        hash = "sha512-K5gN4yG7bbUoebzQGotEaGydacr7SSb9djCKQa7Z5tWjfssAv7cV4+MLB/zNKDwRXHP35QeNBAYd13/5O5xLig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.9";
        hash = "sha512-mp5LNTyV+/6HhOF/TpLSb80GT1QXSjTcJGopjdDnpVHEwg6Y1jrNpO4ql1qWTI5GdqajHpFH1JkKNrhsrf5VeA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-vXYfxVENbn9MM2LtGHIIbFA94DMX5bLEjPJS4+9qeIkOVoela1+v9u0/29FYxJOiSyJJqhNX/oViL9WK27n4xQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.9";
        hash = "sha512-h8iJgGNLWVypldVPa6IPweKvdoryehrwJjW0Iu2OiqmySUuUqn4/m0/oDJFDuC2x+NkwfOlVUEArhuU2baoBhg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.9";
        hash = "sha512-Eyakl7XlhRG3JV1Qtvhtz/PvdEYTaNTaoyMTRCOZ4kFEjgGJfPGIuocbyN8c7LdXvkW+ByQMRt1Zrv9BPqIr4w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.9";
        hash = "sha512-PFzdcirYlGtt8PF1P+llv30AEyM3UiVZs78HGwk15UFdSFWvzmzgDBb22x+453Jm/jZblZ0xBx6Ad9ooc/o/bw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.9";
        hash = "sha512-T7xrIGgBeF3dTKf3hnDgYBchs3A3h9BYaGqiRsFqqPWC4O67zL0xZALcc22nrqpSCIt2t20Yp6U/m/GOQOkOjg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-C+mWSHEig6fc93QZvEOyyVNJAwRff8Hab1aa/FPXk7UPDTu1Aa607Q+L00q7KBMjSzyT9wS/3EPHpNWf/lKLKQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.9";
        hash = "sha512-EKV16pqUBpqbCeSd19tUzZYKBRp07b12C4rGOzxDj5vpva5+0o4oI6gpQ4PNrPStxAvLkCn+lW4V5t2dNRRPSw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.9";
        hash = "sha512-YY+OakLhZvbVDKZbkRPQghLjCO8CYk++BMmaUkQDBuQKA1YVX0rs2Ku7ywGkDjlSnaJ0y72YlN+oKbl1BFrD9Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.9";
        hash = "sha512-/ceVrpSp17DdHQSE+uQOJsptb2ffZhKRecc1xzr30TtCAsp/BQme6gch52wgJzZQYOVHvnIf9YntJCCJz+Dg7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.9";
        hash = "sha512-kmCiv1PQSwbIZSrTzBDTr7qoDLZkwUEaIwKh6Rr1MBv73jK84K10LXZzFeh30oG/Hs8oS2Ei0sV/z6XYQNkFMQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-/Hb7qBv5SYSt/sSCv3hrZOz2Lk3mPhbNrm53A2Xceog86Kv6Mb8G3tg5zjMse/L5XT0hjMzzdMe5zfLslv804g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.9";
        hash = "sha512-rwSCK2qACEhONejs/902VAbGK3nDbsRruTFqcBU2dWHQNBdwRDestEmUNBhXNHhmIVHcD0Z4T1QfmkbWb4fsIg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.9";
        hash = "sha512-APNXdyFweOEB/Tv2NOnOOaqz+vxaBzvJxbc7/P1zThc6n5PLHERu7caLTD34Wqt056d/Vq0BK4+GiP7ByCSKNw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.9";
        hash = "sha512-XM4yHVQAzj+DM/sZ2u96O4joEEmImVb0ikGAKiS+MDjvzxOIp6yG6tu285AOsfBFJQWK9ZcsF0aW/lx5cXFNTQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.9";
        hash = "sha512-Jf7D/khHnHxvcq+TbDFQL2iHtZCxO2NqPi9/tFX8WV7pPa4ApUqvyHR+ivRKlPniK1tFa0x1azkbPq8TUfdIRw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-Z/dN+QsM4JhM2gZpNim7v1T32mLOJ8Ao6Mo9V58rrpnLGTVwRGDCmGkyg184qg+A254/Y+3FwdjP64gMX++HzQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.9";
        hash = "sha512-Y7B1SSEHJrfUQ8KtMwFrJfiL24ptFE7SbBy42sM++Z7MG2C8lw3gH3G+tvUAvfUXyOiW8pqeJes66OAdgVYBIA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.9";
        hash = "sha512-uJTCSZo0796fS55rgWDj9iU8t3qaFC1JGi8W4PpegDogbfiOLafh86UFqbsimo+TeMJvhS2qRB6H5HI83TQV7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.9";
        hash = "sha512-Mcnbuj713Fbbhq7oq9ZiEZA72SkgMPMNRHXbmoUXGEVcD9XTRwDtmVncxVS1J724/sNfbUaJGha3I1qHn6+QEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.9";
        hash = "sha512-MAiK8UM5rnWWls1js5dFtuGfCg8BYjq0wn+954v0tiub3SoBAhSVF778JOFCXeSqAAyNxABHIVcQO4k64WxUWg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-PEq4RRyAotxO87nL93vLgliuwC8ujcaG6wN3AT2CjiH55iNYCrBoDE97gAsMz4E/pU1wsB6NEv2iT+UGftid+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.9";
        hash = "sha512-h1v7FDuCvpwKkf8K+dBYAoVfH23bQFZ+ZGYSQ1FtjpgUT+I72zhAa4BSCLKPKRrO5XyyLQYwXrJ5Pl4j2qlaCw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.9";
        hash = "sha512-4xi/0rYDHw7BTTNG5qFG1t+j0yJgKapNAnqVU6CITNSntp9YSmowpbHCEDt3R2SQKwv+13UiLTEqa9oXY1iUeg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.9";
        hash = "sha512-d5M6A+y8F/Wr2ygrz6UeSuk6iHLTcjWmtV/dKhBu9nwX6BpSRVmOBxF1Gm11BeDljfBbWgrC6mJ9RNDHweQUNA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.9";
        hash = "sha512-lgsdY20SoOhAg6cMvoT5jArQ1ojaTxbbglhoMkvlcs9iF9OD/4WQ5pFD5IU22AHF2L1VOHvEqFpMDaXe2sdoBA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-MN4etKupFdMvsyv/uhuNoqRtsXo2Usx6J620K7/BjuFBNa6zgvIU8Twtdca/T+nXv4UHekuxnAWPfi/qDrmeXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.9";
        hash = "sha512-DkugBPA3r3XZ5ZckKBTyJbHinyq2aSGEIYwbrzV/5QchAblS01QuRwp1Ti2V3nkxeHRi91nznbEUsYLgEJ2CgQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.9";
        hash = "sha512-7yOxx9oua8sQI9tU1UpxesK743Ed0K64G5kCDuxzXpApc10OxyrzcZjMqqSIhNQ+9n0x1dg7bnYR1Th9DbgBeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.9";
        hash = "sha512-YGePjui42vW7XS4WYM1yBsSJO7Y4kpiAO/See1/N/khhSbJE0LNOCgBq/+bVCQe/maFrPAsE8Cr12/a0k2vgSA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.9";
        hash = "sha512-T67jAZdMxlud1Jnvqtqtivw9b9nBsxGFH7nK2pMyvtsIzY30GRuXtcmefNlhcy5tgbpbIQZvB6OFLtXELxZGFA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-aorMP1CaVKXlgURfCLUozhrkZZLnqtZcnyqcUCFDJMd2zl/kqjs0UlwNBLVrHLOU6HysLzXT/+ZNXAQTy6sIng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.9";
        hash = "sha512-G6Xqdu0+JdYnNIz8CzAq6SNqt0Ux5rixZ6DJb8J/FjKXlmznkpB0YkP4lWWuv6bHWzuoHLt5ouJS59pPzjGnpg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.9";
        hash = "sha512-OXojsmDfMeUljicGWrc0IPGebgFoOYlSf7P2h18Zj5yX5iV6+YhxQLayXaAb1UqMPGm1XQYG4FwG00G9wt6LBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.9";
        hash = "sha512-TLv+2vBDVPZt9DKVz041hBwvfZdxgAfoR1yVQNK4nU1W0V6lfA+WZFeoDwHQB+PzWvug5TtnOHH8SMbQhUbmIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.9";
        hash = "sha512-7+eRiwAdwezqdMUai0mepMBWRYwGVodYb6Dve6tk5kY9s5pOk1giPurPvRKn7jjpczUPayeruGakZN2bFd2byQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-A40fewboaNJYVc9risXgyEd43buI1tTNBh22ltEiasBgvZpFepOsA69+k/GqgBvEHkm9MZTUcEvNYDv+tHXzDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.9";
        hash = "sha512-sBmrd/ZclsVv7pHC72Io/WbJjxYuXrFFJViGgxvCCi6PvUKOAyk+D2d716Rxpb5H/mqBGmPBxPv5Z8mZteALxA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.9";
        hash = "sha512-01Vaix7bT4s+hNGGdesbA2PJgt/ZNh6EK0lJkXx9WuQ2nVI8NxmPVYldhPyg8BSmW8c4nctnE5BiKpXrGkDU7w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.9";
        hash = "sha512-JdypSBN6UvEz3idb/+fCa1TYgkxxrGqLr0H9K2lmiAP9+PafKY8DbNXR6KdkbVbEEsgptdHerBQuHiNwQ9qqDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.9";
        hash = "sha512-HwFK+0VCsZeix9kXJeaozQ3zpMIQQSEyJXtm78a/gF+m5KQVOYjnXLt7SdqgwjDjSEGSDQqO4oWsdLb4BFrnow==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.9";
        hash = "sha512-vobQxamTAn5mGFIu/ytkgmqKfEOQEUeOSCTBnE1TIkgy4pqesUb3j8PNfExPwU0HX0K69hweFBI7WESYEn1GEg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.9";
        hash = "sha512-T/N1mlIzeYm86qUs2fIoHCZZRWcBD8ig+rnFkFSitPyxP+Q7rU7VzsaI2EVL8udmNXP3WmGRP366YNEV0gpMeA==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.9";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.9";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-linux-arm.tar.gz";
        hash = "sha512-eogmiUklBGLDWcGGZbuUcmMUt+MRgoZPp/0l9AjnC9YBvpFHu1ZrAJn3lmDLbe7vNU40SyR07j/iElqgP/iPlA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-linux-arm64.tar.gz";
        hash = "sha512-Ezd+ymPVKoW35xJvCtawF/+9UgttldsLoF62wVJkXvQjj4o3RNKwSsQY2YVu59tzK+knqr3oSHFALDVI4f/O4g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-linux-x64.tar.gz";
        hash = "sha512-o9H8VCrfwlMumorERE+wU5787DPPcz3mDNX2+P4+mloyNrmGlLJs9z2c110uG8oMaR6D1BEH3rxM+HpaspmoLQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-linux-musl-arm.tar.gz";
        hash = "sha512-35q2UCA3Y6i7Fp3HPKNMASIfUPm8HEyZMwecSE57W5vfBLs13ltZrPBDIMMLkvDJu/uUsfi0Yd8RIBi2uIJdIw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-linux-musl-arm64.tar.gz";
        hash = "sha512-eg6XyvTepdrA3KH/UpcaUBKS2uVcrDhEFCmMOY7MT+lI8i9L9FxaWQGIdp1H/EK7xfTna2obh1/AyJUZSw5VMQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-linux-musl-x64.tar.gz";
        hash = "sha512-eLgnl/3fO/RLvchMeVcjbWDGpySbg4IGA+hIIxa44U3OHooq1xyT2PlKCi5bgcFN9lrJ1t7BN/XbZ0li/KDp8A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-osx-arm64.tar.gz";
        hash = "sha512-zNJDbv7nVohCQV6+QlJepAxB6iXUiopV88UmtuOJMJqcfAfkfHKrTtko0z25RhUGOVJ8jGrLwTz9/PjG2rEZYA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-osx-x64.tar.gz";
        hash = "sha512-rEqeh018sSq2qZ+QqUqIljHaKKtfWxF7nJ6pE2k85uTwjlmInmc8Edm6Ne31NiOsnRgfAavr8YZCPkxK7A0ZtA==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.9";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-linux-arm.tar.gz";
        hash = "sha512-1xQT/lIJb3y4ukQQHjog7tNYnMGpajty1Fxccpk8DFn1KqUyquXFe0JPArFTjzfb4hhAk7NbojryR15nAJ8S3w==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-linux-arm64.tar.gz";
        hash = "sha512-UPUQe0jIoJic/8o2omg0w5iKE4wVjdBiJSiXpszQmLTmYFnZC83Am6DpLRJrKA9oZobTYjMJ+ZTr9EvDgD38rA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-linux-x64.tar.gz";
        hash = "sha512-5BP0kU55EeHNmUqgHEM8sww/UFs2n/VcbGHRMNzUMF4OB42+ncBbJ9EFFM86/OCPx3l7xk9/oNmUU4GoBfhcuQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-linux-musl-arm.tar.gz";
        hash = "sha512-UWSwbvatCk7hPk5v6wpT7rzk1P6/S1cs/oyQhP5l9UZYvpvFrAjuhPz60/iKAmoJ+Hi/gTYtZWD8GOKbHsf2aw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-linux-musl-arm64.tar.gz";
        hash = "sha512-HKNrpkdXQhLYoPzkdq+72ZYZY53UMt3S8lsQjdbKQp9ng6lFYWq7J+cKyLVa5Izdu5V8KwA7LWEl4qD28v9bGA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-linux-musl-x64.tar.gz";
        hash = "sha512-R6HoBR1v9zNDYEO81u7E4rC1fWCZyjd2vJeXmYnRZKDCTTJ8n7zkemU4luxLxCQpud/zC6UAhtSNl+4tdRB5GQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-osx-arm64.tar.gz";
        hash = "sha512-6KrIxX0gFa+Lo/Camoh71GktoXJfsVw1UoBxIWnLm1BFAsq03N2vLRO+lzKdxVJ4E7zupl+/vOWJIVvk8Vl86w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-osx-x64.tar.gz";
        hash = "sha512-0VCAEhVBsB2r/GVnz6Pq/M8nxwH3MORlr1YCl5FugDRRdb1e78m42MMkJNx2IGIoLIqY5FSJ6s5ntRDbbYGaug==";
      };
    };
  };

  sdk_10_0_3xx = buildNetSdk {
    version = "10.0.301";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.301/dotnet-sdk-10.0.301-linux-arm.tar.gz";
        hash = "sha512-D3VCsMeAqT99xtA8GgnxzDWHgcmreNc2dRqObmLjkDfm+gb+lTOwn9jLIbdWtgqA/YgHIBcSUUSGB2jw0t9tSw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.301/dotnet-sdk-10.0.301-linux-arm64.tar.gz";
        hash = "sha512-TuQ4s2PLhGiTDVC2vcc4o3Xi8zslv9DI3LVYU92n8PsYdpPg9J38MVVuaDILlhpQ3PO3TB8lq+OlvZFttgfbmQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.301/dotnet-sdk-10.0.301-linux-x64.tar.gz";
        hash = "sha512-z77sOjodOtPhaON6d8TMJsIxJazYSobQFAR9o+z/zkw2iprKxNfJUKBH+j2YmJzorqafjlhCy20zDokR4cM1pw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.301/dotnet-sdk-10.0.301-linux-musl-arm.tar.gz";
        hash = "sha512-FEX+3x7tD+2OA4vw+5L+zRhoSIx4nwhoeNr1KFM20jl80JgLGY7nWUEsMiEFBDpWrbAj0Et/OMG0KFxbWPRO7A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.301/dotnet-sdk-10.0.301-linux-musl-arm64.tar.gz";
        hash = "sha512-2WBAlAVd3cj4fSdet5KZGRRRGfLNMlK1qOrEqBoHZMgKgj6oPEVIu8BCKIKc8g3ElGYKDWnSAKS8wwWIJk3KrA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.301/dotnet-sdk-10.0.301-linux-musl-x64.tar.gz";
        hash = "sha512-uEzRDc8TtTcDjaFvPpxkJftPQrxxAJYsts9nk/z2UCOAXaSW4lHf//Qq6x3d+8l1k70K45n4gebir7lU9LUB/A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.301/dotnet-sdk-10.0.301-osx-arm64.tar.gz";
        hash = "sha512-eXhzc3hwRDW8tG0aq/SCT0usTHK1WbDFeW+tzxWqKsfhj9PlyYPAvLSMYHk71VS8+wyqmXITLPiZyXzNdGXZOA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.301/dotnet-sdk-10.0.301-osx-x64.tar.gz";
        hash = "sha512-oOszPf9u14leayRp0B0BS8OnToYytXBOT6tVJHspweF98MUuhX3t9VCS6+ZQxj2nSdiwmvcHvCjMJaEnlrS+Eg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.109";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-linux-arm.tar.gz";
        hash = "sha512-Knhc+kT4IIKhxk5dW/+9UPD8rA10o+eb3Gtv2ykY5Sskoll0m2Lz9mPct99JSOLR+18M+MOae380Da5LQRfnpA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-linux-arm64.tar.gz";
        hash = "sha512-ue9VTcNGUhSvxh2Oz7Ky6cUbrwjwfMOG7zyHqmc/OPhkdDEeS+HRtGYhL4zBMIs9oBOY+MSAA8S784ByO6lQpA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-linux-x64.tar.gz";
        hash = "sha512-Vkjo7b3YEnRSgolkyovmMboZt1qkAgvDNS86uGG4tZgtgj/Wo7s7dB7E4/3GwN6eyKUujc7azM+eh1QlBXncLQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-linux-musl-arm.tar.gz";
        hash = "sha512-zIBWuArYGbUd/w+KROtZSVKzvaLo9uOAxc/MGqsWoxPy2GjawpShFL2iAG4u8RPOaIuJZXn15HcQAR4GVL7qpA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-linux-musl-arm64.tar.gz";
        hash = "sha512-W3Rpmf+ZKCnKi7VOTgNpNmohxpS7OxaasygwHM888Lkf9xOYIx/qGA2fVjy3E3vOYk/+JumOPrpZ7i/ISvSqNQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-linux-musl-x64.tar.gz";
        hash = "sha512-G/9knewkHzA38Qk1yJY0FW9r1YTtOPS5uMshozH+wM42MeQkGvq/+c3QMtE/GfRAFTMT3SGxyFgU/J/D3wJMew==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-osx-arm64.tar.gz";
        hash = "sha512-PtUTT6o28EhRF0wgP8Ynj0PvMw+AytE18YOYZWlf5tCCLJGMVxQgCz8z6IZShw0ptLBF4FYx4VcjolNTDaFDCQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-osx-x64.tar.gz";
        hash = "sha512-yfVfTCJiLAsyY9X1gYMFAvpT+hMhtPNHgmbRtX45s3jKLti3SEflgnRBJKFLWjsHODcu0a9v+UcKpM/UntbIeA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_3xx;
}
