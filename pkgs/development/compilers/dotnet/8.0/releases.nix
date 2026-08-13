{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.29";
      hash = "sha512-xzHGxfA9tPFuRT3Mw5ZM82D30qRjAlo7+9IgQTC3Yk4gYXH4beZUhPdJ5vsfFLVT18UjWLMZnz1B+kUTfrbMwQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.29";
      hash = "sha512-z+nZiQHFDKItMBkN5rUQfJQjlqbxbFmcuFQJm7YG3N36or0axsSnC+HWsSQUeiYzPwYPiJDaAvFvTEF2zhJMMQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.29";
      hash = "sha512-MxCbP4EyXRlKy+3qvEL6rV71FCBRaUj7SOHxP9gVAhaCzXzkrkUW48gjiBM8cZEZj5md0jSoifWKe5cA/q1edw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.29";
      hash = "sha512-6BO1kFx4oIlTScK/VoCGqOOi7kUyjzBc2ySCBaxMhYNx/gX1/23pJAyU6oYZGWAyR+HcPqeNTaC0vDlsMv7yHw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.29";
      hash = "sha512-mHSQRj/brsVynvD1GTH5CyylG0Z4IFhHPuHDly1koWOeqLdgVhBMx6bs1CVZHE+Fenbxh5dry0aFmcgKZIEBXA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.29";
      hash = "sha512-jfyPz3iAOqoH5cTCtje+prbA4n0eDoUHE+QxVWHfic7JQDxY4HSniHjAXNv2l8vYQo3Ca/NI0edTVhjj4xbGdA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.29";
      hash = "sha512-zzt6uxth4tOC1Os/LzJxYdvx5Q5fwBaUz0LsEN94iLqSAZvI61d8vEpyD65wb6JYa9xrsokA7PON+7DPs877cw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.29";
      hash = "sha512-So7cyQ1DqVWswW05BrxkC6dRpyz6bFtGFL1PqGtDQ+R+KXaYkXBM1nchq3FpUdxfvNnFtCnpP2Jz0HByIgLbzw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.29";
        hash = "sha512-dSDqAfWuUz5NJ2L+GH5jPnAtH5OBpcJJapwN5oV2cRNOXcRVpluwqPYcpN4A4/snxrmFjDnGBYe39vL2Y68b6A==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.29";
        hash = "sha512-T8JbvNfBQhgeYkkQuEbrGdQe5PgDYL1+mSjpuQcdoKw/dAhUulelBp+qND22/oox8bHkYfcMME4+/kBLZt6dAQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.29";
        hash = "sha512-KfQwOQveOQxfLxMMuD9PRG/vDvdeGCY/VY/f1vfEd9Q1TuNJxYfzzR1drlO59k/CxgMYp+aXoq/jC0KcrQxeMA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.29";
        hash = "sha512-DZR4wT6pXdPuQyTzK4sEAMe/+5XZJAIkYhMUQ+vUIXZmHWNodm2kjxAFF8E+XmdxTrKBsAODwg7qeErfwlNTWw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.29";
        hash = "sha512-dynoNE/PfqS1gOURf7p+dtA6+Y/r31Tzhti3H2ZZbAYJvlZK3muBHV+k9Tktqalb9Dk68dvp4k7p/6gQf+m/OQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.29";
        hash = "sha512-xmn3fIYtA/SZKea8UgFW1QBkDTloAqtLTV/6oVC77DJ2+c+wqpL/NLhSfiUe1Atcb2mzqinxwvXvinqSczKgAA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.29";
        hash = "sha512-sLOw4K+er6uyBA6hRAjkf+IdO8osHTXBoSJ00qCjzVxSMaG+9nKXA/kainBTdkMjsVgc9dnzUziwQvWfy0W5yw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.29";
        hash = "sha512-qK46ULR63UsVniff2UJnb+4g+BWlMSmQlggnoa38tk1auzuTjGwWhOy3OPkhgVyoiBrl+3mFC9h8BeDo4kWCUA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.29";
        hash = "sha512-EaLNfytGHqKkh7US+s8ltu7Lut7Hf9LIYKD+9a0+CD08nimuuQnlOjzaLEN7swFEZPvyq/2JsNYcCDP778lVGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.29";
        hash = "sha512-gNI5rA/MkqO15s+xPN+H4fsDq34qtIKUQ8Hpn9/8hBsg9qU5caf5s7nU3jkHqLGdu/V2FGMH2hPRi9XKGMm54A==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.29";
        hash = "sha512-8TXwZy+tUbPdyg8TyvKPYICm5aGSr1pzXu52/CK5G5IBIrhM7lmF5bq+fZyjC5voZZAWmBtKg1/CGyxV87JhBw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.29";
        hash = "sha512-tEdUT/3zy5yBPnZ3t7bU4cWFYBLum+kwUyslvPG3tjlhx0UGtz0SQNlF0szQzpd+s65xv4HnothnnbAQ3S0DHw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.29";
        hash = "sha512-63w6MPBw6qTnO8LTBZXJjpQZKl4g2PdMFsl/WnuHIUHH6xX4XbQ5Znxee0GV64+UXk2Jb5cWJrS/AfdE7hW3SA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.29";
        hash = "sha512-otiu4DAv66o4cUMG8SF5j+D2wA1joAeKTeXHrzXs+EE4BmuaB9tIVjzxLwp/hpW+Lv8e/BHBhImZSthxOBKC1Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.29";
        hash = "sha512-DfzFIhCEOcuA3BVarg7BmGLqOG56KwdBbZnkQ5VEbxWKu0WzrLU5ucsIwqJzJO1qkFpfwElWZh7zbZ9h1oj/GA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.29";
        hash = "sha512-pw3dCJOk198oxNf9cOO7GQ5nYLAdn7uMVWTp2PZzo9tNEjbNO+GZb0jmYZI/y2u5CetyS4SyoTYQJ1mRMDJ+fQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.29";
        hash = "sha512-v7SBYc6VWyYiSVgRP0vWOvlPcNHP1c7NqxZb1JCmMRMeCSmupGhg9JF5Vzr1wfXKC3TcSFUewbszshhuRHzoCQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.29";
        hash = "sha512-yW0vT5c/Og9+yNx214DqL7XshL9mUcI4WZc4uZRKgG5MFLmR/kJZAOxv5ewtIk6KfFU4FfXazZzqNEmyitwFOQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.29";
        hash = "sha512-AAnWqPmf2tCmz6kY2NquOOOhDwm9CRLWnkigiU/apKqPyj+EV6lj5Om4nvD/Y0wqYP/GP4KCW/+9WiPdY0cqTw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.29";
        hash = "sha512-+1daD9tuyKzV9o8ERMyK6VlMf00RZSxa+11nTYU5U+GBnnbmkrkbPCDGsIeUlJfAtiGiXBMnLPM9KWnTmcwyXA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.29";
        hash = "sha512-GZwIB3ueoQdlMxBdUwfeoAn0bJ1BtmTCkq+5u9lnWAvP4gcgJu8UvbmHcpmomZuxVoH+wo0T+7aOWhpx4KCVMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.29";
        hash = "sha512-PneVBzH7zHyhcQfjShSQNxs3/K6PXFhdVPl5hLLjs1P+UEY9ENxwXY+XN2XqpU1CsDABpv9IBncXYAKWJA0RuQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-bOouVNHMR4+bA5fuWOZmNWtOoVeE7Y6Z8FjvSjJSlwmLhTQ+1yHkryYy1fSOkWkPxaEMP43nTDZZiQ2wxDgB3Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-9aH1L8EkZq/sWzOHDMS2ehydFIz2YrEz3RBRTRe9WebhYNBg+3AJIr1FOIVIqxO/IwgRTy5kuGRb7JHsO4Xksw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-t2Qovrm6Oqsyla9vzWttDa7fSPAOIQ/8Ea0d3ykrkWNyA/nXQJ+2tV+qYq6cf5OGu6Ov41h2F8Vq7IYzOoEYNg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-sgFP1ENxUQqR8vmcgdOcsNkPLNVnUfC2vAr7Ey3thXdD6CGrhh9r3Ckx0V9wu+mAqdWsadYUyigqalmcZNUY0g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.29";
        hash = "sha512-UoXpzJvxSMe1Hxz6WXbUxj7uhxpDZMG5OzF+WNXXVI7wCpVGtYEL6y/qpcStOrmTuiQGyLkRq0fRnR4xnCKVqg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.29";
        hash = "sha512-dPP2jtAgqEZaKbr89MPxRe0cvfVvgT23Tzi/IYpOxnlBlKhjqYXVOkBWTZ3OAmGIo3lmywsYkd2/aVrA/D4vEg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.29";
        hash = "sha512-ecdcntpVCC64h41CLpTVPMjPACTMxJfFzluaH/PNExph8cyoJNpQTkGKFd2FaDAONye3g+vWuuPDFy1zSXdyJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.29";
        hash = "sha512-F+x1YJDJePhuFFoDfmEz42bWB1UzbStAzOtUAZQYXGucZK9U6x/D05/2KwFa7v/u6qfCFz3B/V8/Mmocl10A1Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-WS4TQg3vyqgT2qynqvcBFsdd4k0ZddGCGlv1Wsh+OioY+k2z0l+YcvWGDaSxyYucqIekrld/uN4TMuUeP8L0vw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-qRZB5vSm5N9dSF3s8DmO+rsFZGu1SCO/X2CiWc5alreWPSavDs7c+vW9PMTk5/6yXaX4FCOvMwlKnYNly12W3Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-YsY7c6hEAC1nV1IiEz89I79OGzpN//C41VtFPEwLbOhysV8zimZStDAYINiYqVrfsHD7hHE0yXXH7lrIK9yeSQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-fJ6LMrveaRHbhR3vif38fPqsMus4CHAG7arOiigVYm/qt41cj0AB4Go/NWsSFmNOkCwWYRGRa9klc0mH8DshOQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.29";
        hash = "sha512-A3ahRo73os42gF7gEmREhi9UE2xD0mBHaLaCl02R5UUPbRCj/D0f1Kptce1IeWCQZYBLUf/eUL8FvUr/Mhe2Kg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.29";
        hash = "sha512-jPamPfiMdPQQG1Uh33v2R9sl1iEmstMd+1347F1OM/3dZxz5HW9BLVoozrmaHK8EkbBfjkiFY7PSJxCEmsVtGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.29";
        hash = "sha512-QMQcl/tKfprylbwqrpnldH4ZsIkYhE1NNA5fCzC+MakAildE1KeuW/+jc58pPvHZh7h2Mhgl0/rA9ifbXuZL8g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.29";
        hash = "sha512-+QSC3Hby6bbiDfyImo5gZ5Safe68/SmxMCYDi+o+SelYeWDjycca9ggf2PJJ8FxF82UabON1fza5EOFo7PJ83w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-Pl7CaV+XxmvpDr0yejRDon8vRJFKejFopdoL9KuGdpe6Rm+4RLGx7soj2nFMA63KqlfGsmphtC7jpd42uIjNaA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-bsxrAF2IihqE8SlSISNJJi2+R9gqK0Srn7X5qFOdDx4WujSVqFBFCtxDaY2K5PzkFsDIXFctwVlsKVtPM5BT0g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-ZnGEH8eGZboY+q0/lcTdZDhUaG0r2GuyFvPemksSx8tGHR4mP4eBL/wo1efOdw5vg3pvqF5V9V9tmYL2XwW1ZA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-j/WWRy7AUpCOoJeptzZ4Pybcx31zy6GJg5F79efrxkdoo6ndJ8ovaNu52has6kxJ9jM/29HKmqb3qFakyD26gg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.29";
        hash = "sha512-xIQLp/dlqTYra7qPn3rTWKA6vGx4zYHXDkxna7ltHu6b71C0YhZnEItgaxHoBKI/KYzKtfVPN/Tajo7jVPq5jQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.29";
        hash = "sha512-yw9eXg2SIxPbviv7Mt42PSVY/bgINpNhpC4c4i+f/5TQq2nkc9yhIvI0+CfbqDuz+TdATZg9XCY8XIQI+M7tIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.29";
        hash = "sha512-d3RqrDXFLqAeEQ5YTjbaOwnRsdWK1gsyexag2JfxvlwhHM2Hv9zwg/MHSdXGi6CtRhWqIoSzaJQ1lRMbIZ1ywQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.29";
        hash = "sha512-5xv+GX7yGxOuuiTi82wKXQdPSSvThCBOLGBgB7zkTWv+Qy4EUifpCTTnmv/nakBuUO22knOyAjpRh5nM91lW/w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-BWcYMh41a3v3FfBf+rynEWxn98ud23z/OH2vwJt52uHF/7DNbY16C9wdLFb/RuI+H/jjbRBdugKp/F5cEeNaGQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-yLsJe5BFmpR75CYxme1aA1X0vz2qMvwSl4lUCbKIxnOoHBSbebxBpdIgi0EBGjUeLJyouxxwr5DX8ToM8HsBkQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-kAUrN7DNv+ZNvqZRIlypm2PJhY8fktKMxx2Io3sb/Jbwm1pmngBWwMM4c5HnU8AgGz26SzDO7QHjkjvQAfC48A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-UrNa+FsyFN3UcAdXDUl/gBVJN/Dcn1ZT4st+olz/ygH/Qke1FCjNXTg+EqbhSZocBosfDpeqmRCXjv26PdDDXw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.29";
        hash = "sha512-Y9of112YOuld2c0WTYR8ZqLkyKB89zxV5ke57NKxeC5fp5T8k3snPFjnBtwlmqZZy5DCmmZlve6J6FOdE20o8A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.29";
        hash = "sha512-6GW54YBuuWLJWuHnQmkfhw19SAnYtcp1p4EoVBpjK8ItLQmEz/P65mDSisvSE/o3P601drJ5x+uWSyMuWMkUEw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.29";
        hash = "sha512-DC0wOaHyrG+soqIruTY3zVXnS8qBQsaNTBGXwflXEiphYQg4OX6KXfpRWNteEoNUGwQaXklgW8PxzTaYBsDTNw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-WS5AO87n4VJ9vqLAUt1QmvnohYiMVPXfqtpZZsqwqQFtd006C/s+LcrgQsrIIOZ1MgpdAVO0tRG3S/VM4POw9g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-+/z1qNzphBAS0rGqNAJh/jNnwDQF2XmJWMer2HFPj7kF/axMFJGsgd91TfBsNisSpn4T/kyjOpu1NjGbjBhgNg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-+0WhREkbh6rLh5/PE41pZdEQnANQI5kHyeLCWa9ToWOpd45H4MFTrWE+qOfTJ9GOqckohWuxpE0mwYo+tV71vw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-15mJJZmq11xkVv+a7S6LBRw1VWVJ+0AHwhRjuFT4ijv5Gu+fMrAFsz2x6VC4xBeSgUNbleE4NuhZaLbXYYyQ0g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.29";
        hash = "sha512-wGEPaUQDF3ewzEHG4a02qE/6Yv6s8QgUQrg9lkhm3lnbu/3g1MrBSYjr76JIL+WZ2sQOZ7SK6dGaRJeQgVgvJQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.29";
        hash = "sha512-UeGqPa1Ock3wdlCK3h9MbMR8mimg+8a3hjxn+DOUe+O2ndB6omblFoH3ahRATvMuHWYzew3F9a/slt8hv9pT8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.29";
        hash = "sha512-DNm/BQTCG/ETEqzjGWGVHYLXHRRyDZBqmY8vNVidirOa+6s2sJ1ach2Vbn/RjiUY1ePWHa8nlYKLA2BUXE/sfg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-7uDIgDwsB3gr4WFezxW98uzPbfOl88+6J+CwxXxAHkgabxyTCInuAVaRGGHSFBelgezmvoTB3vfEB84W2xWJig==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-UlzStKgLXGODc+BZ1dDYl3LiN3nN5QkHRGlDkqbBbu1EzuKhWGC0MUvnY7tPrRJ8Zp8+1My99gYZCy/9nIpjiw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-CAs0LPasV/efH0yrJ5MjTO4brW0+gFwDNOLmWWsOA6bcaVQ9bftZS/gVWcZtZAG46I2cIsVV1vgyKUKJqKUPhA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-4q6kPjT3qrvrNy0lPAly5KxeZOl2xKPQWoxUsYmEn+keoyDpQEJsngO9aQcnWBwNwVWLFxjlJInKImPCYuQZFA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.29";
        hash = "sha512-v6/BLmtLExT0XXoCVVhcr0GBIg5H5TbSOcQir559doFkfhg0PVg7pWUrS4SFxa9OFPpavQu/qc8I7MGfQieEGA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.29";
        hash = "sha512-SWhJfTl7Q7XjuZJZDuvmav0CEwcGaI/dlcX9HnvEI6eipaa/7h0tTNTHR5v5N4XCJ+sJfiojPJb5JeRFf6LCEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.29";
        hash = "sha512-dA7+gb0KceRUKOZLGulU7DUyRPN8s35RF2kmeFJ8V3mpyE9CgWU9e5nDXkxE1ZJOro7UxsmRze03ueBR8Ull+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.29";
        hash = "sha512-vNVJ8u0XEUzuN5xKvsI5ey5dF1s/09WR12ul5OQJsQn+ThNCjneH378LfUa8k0Mwb9wF1nxEDyUVOT/jaJv/yw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-H94lPYjH+f2h03yP/IXMOxLVz+p884AVnd/ATr7kgWKBcsMuxtilxlvmSWdHwwmMc9EyDl3S/xW+W/vZZThNew==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-w/CvCgKlq/jaqMmOZ+hAFS/3Th0xF6Jaut+nMKPX2HrwduXbuHZJlDK8Vw1BUxHRYGgyOMDCMXymO58HsBQ5zQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-3NsXo50XGVXnaZfpvZIM9KODBpuWSEeoBLFqe4HCoSelJAVrDqi5TvSThb+jUrS1cqHjWKPMEW/MQqgXskNISw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-Ayz4t/mkkOAoWuQM4TgF6ImndZo4/CiMYe1MAy3qR+E3S+qDEN6Zf7ZDtI56Ra8OqV+B0TyQKd4ghNneEOUiOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.29";
        hash = "sha512-XzF8C2cz/jgy9g852ip3gBS8hAp9WKC8IkYuge9o4fHAsIZw3SOgV/gMLn6ijRp5Sis1NljNaheCuft8sSJZrA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.29";
        hash = "sha512-tFKB/+yCkoFC74iTVYQT0RZX+A/Ekdn2gd0xSWmlb+1aNHd63YD6zvRQZseXezB8KOCpQN3BLy+nr/xg48gJPw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.29";
        hash = "sha512-ohHLyo6QecmQeR/ynRQc+kQWqkplCtciB2bgS1/2f9d/Qo0z7rADfDD3ZyrHRi5HECclBfHC9zgjqTsn8cWoEw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.29";
        hash = "sha512-SAPpghxpxNQvvdxhQK5gqAYLF9yvghfFJt38ADXBwAMtJUobVY10NFOqQFpMLiEQ5MBgGY/LapcunHVQHFnerg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-Zw5WXj2mSve60CxR2d4FJSjtiVcXsbXx/HDe3Hd8nVhbeqGniYXxuoI85IX6vHPquxh4W7wfw9GcOc5rgYl/gg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-hbyq+4gQJZM9ryh0RupRqaX+PxqawG/+zMrY6MsKReRPkmTLVI+AqzK3/BNxUkC9CYXLBarPlTr8CtRYmXqX3w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-pJJfgBngYZMr0xo0cMT+VBbtqM1kELnoP1D6mErNBVn84V2k8GAylNuJADwscWe8BaOjKOlaA27fsb6iUpEt/w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-E7SUO3Dkk9f2rhciiLh1FxIgqwC1XQrjx9Xquu3wQlWkU+SLNhV/e1gfEXJC7Fw3FT6piXFSaxFckzMeTWfjng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.29";
        hash = "sha512-BDAirbKZATlnHd5KIMkVLw0GLIESF+I4mCzmVDONiRijJUd55fy6VljGybJLopqhV5iN1EpoLphXC5juSejNmw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.29";
        hash = "sha512-nJX642UAYnX/8QFx+uYZyFfG9aSnriiFH1tvt6oRXdanQR9LpKnL8qq38rfvvh4Uch9JH7Sqwy26E6LyjRPSNw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.29";
        hash = "sha512-O8xZXAQv8U2xV8PshZeO5z87Z86s+ker3KGcaT0GB3LAujYw2FhYFlU2fH+rIYNqadV4drsnlXmUi28utGPSaA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.29";
        hash = "sha512-ctyP6tMFyb6xVgAXQxiA//Ds92q+iNS7YZd+W1zm1K+ehEurVDtvpBGFkeFoiNvpLHx/Mpoxkge4BioWVTeJuA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-diLs+hkOjZ3FdVCIYlc5SOswFZ+6CDYuToq/iJ2Eb8qgIKFuur56JNxxKcRFFnXteAC66cRiNqdx7aSC4wGXhg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-toqKCtClKOAQl4LdJpy6uzgKfdSrZHKPlJE/EqREtaDwafUjTV9+2Q6P3vk8f2Hj6fZlolOjV4s1Zlpc2SVq4A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-dqhL4U8dNyFoTVDfjl+Xckdcyncd70siCC+9sIDGnLCj1YWMi1RD668rE2mONeU66pqrrJMvS1C24EElUdamvQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-GzGk4uVBaeVrJavD0jp3ogFYs6FBKCh5lGW2ck7nR52cZM5vluCw0iHp5eV9jLvbtdqFqZ5sCC1iu2MV2kMApQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.29";
        hash = "sha512-KbZNub4aIbUWdHAnLEm41ZKact1iVW8sYsIr31LuhdHeoPNnst5ejq2mysxOXv1O3H9qus9hB5HTBPFx4T3nng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.29";
        hash = "sha512-fdJ/QUn36m75yHEkRnUgk9rHRVto1+q1lU+6SxXfECFNN4CZegI6NFBV7Hoj3859MbLH+GWoOqEOXMNC/zPwAQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.29";
        hash = "sha512-XBQUNw6xNOTWm+vblnnpxpPYJOm1eYzSjJpk5wlHvodNU5JXmX5dxffRz8qvqkO4rU5UzN8oruz63yrvP5oHEQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-5k929KONAUYsJinpEL57ROFA182PYwT7JePFBkm+mG1+mc/HGSR0VmHYwTwI0iZMhd2Js3TdnXQuBPFsH/BQtw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-VtCX5/ELxk/DM21+yAxt3cuIxH6QmL7Sz0WsVNRZux1qyv829q2z5tjgTKNGtuieKYQ7aqhbymgpHeP/jjPPDw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-iIIMsCvHy3YUbtJ4iODGYzRrTgAc8PdzjgxQauFWCtIbltNrqYQhiiF/BMfvJN3nxQ9gAoxJ9LHziJgptc/UoQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-ixA83otX5wUK7cOuWogdXzJMFY6hk4+QcdA1w3bjjCr+8ztyJo4nURUziWGGXNvsKi1ZV+iK7hRzgbNYZcV15Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.29";
        hash = "sha512-ARZ38vxG0rRhqxzE/ECDOzitoZaesS7N+lAPFKk1z5j7XND9Y3+SBE8rscIE+B0Rw5DhBh4iGslmNfQuvpjE3g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.29";
        hash = "sha512-WShaNq6gSKlXxgGmhwNlKqBvQNRJL9Nb6rRSnO6Ic1hIpjg/yz/5ovG45FkL7ffoa6WUBL6B3kYea++qZlMr3w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.29";
        hash = "sha512-870/NQtg6lEjN/bDHstAKEaCZMw7sczXDecbYhTYrai5gACwP9lhJtg5YzLsC/YtiJ7XrnOx4OCVKNwvnNAp8g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.29";
        hash = "sha512-XzD3Pu7NoV3BFVokkXws4iN1dOMez2iyQJp2e345AQ6s617g4VRv1ec2ux7+cEX9HawXDMLqrnITzKlg8Uoitw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.29";
        hash = "sha512-XL82mgivyzSKkvS5Du2bCb6df8zOLtaLKiO29iLMNX5byLuULg5zJPfuCY+E21fM4db42UVeezZKJJs50xNpWw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.29";
        hash = "sha512-zLInzZFrPFTUxB3Z5XuxFS9rBBphM+dDKbCSMOpGNMsjFZyLqjgeTbwAPB5/wgLLJ+rJSf5sXipTIECk16BU9w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.29";
        hash = "sha512-xqtWdH3SsCjdC7sFG91vpz2Q66y/00p3B2OCb4t94hJzQDc28eAfFIZ/VitP3lzBe5CaO6TdgT/xhrMb43a8QA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.29";
        hash = "sha512-Lk3kz6YMcVOE3cNqxLi+F7O/UVhePnfr3pJxyW4tA8AZlTdUowIcAEDWFp/iwjIkrNFysMQwYOQXVVGAdUST+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.29";
        hash = "sha512-Fts7JpQx0SedZFcNeJfaVmFCLGoVx4eXdUdAD0986QpEZuiWNy9/x0V3QFZPvPreaWLxxPPq5WFo0bgibxJeVw==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.29";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.29";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-linux-arm.tar.gz";
        hash = "sha512-87PhUQ1W/0VRwc37c+q3gOWWdjyLkWJRxW6Oi3BMkf7fatWD2xB2qOBtzTsvj0NTTrhZvZbMHpScP8p2pCfHsQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-linux-arm64.tar.gz";
        hash = "sha512-j44xL2PqTxmLp9oDTnSGr/ABqprqLtmr9LXCU8hEfQtz+ijDAD/zzsifRka7cwxAWk7bJMX+51njYwzAOSXG4A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-linux-x64.tar.gz";
        hash = "sha512-qq1LnvCajhoKAeMrPVB4WBp1mqbtgLQrfQHWVCmpiYej1LNN6/jU3krgnNycDRy2R+aHElo3G5f+N8OAvxiVrw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-linux-musl-arm.tar.gz";
        hash = "sha512-CDQU2T+nEKbFMxE4HWqncm4I1hq3bIj5RM4V34SyvOLn6T7QkcJZVWVo95BDnsJeQNVmwC9984YGmk/SqG73MA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-linux-musl-arm64.tar.gz";
        hash = "sha512-ib8R8oPMDPbOJy/bu681bw3jX/s0KciP6wXs6V26J8zixBwetNtVoT9CcBkWdy/PBAZggQv86OypnAPJSMN26A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-linux-musl-x64.tar.gz";
        hash = "sha512-c5ipAv+y6xiFsxraS8d1IRUJGOoU9my7x6HRXXpCuezmFUzfYFiXhEYGkC9nRuTSPl9RDuAHXxlWPdYXWBWrsw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-osx-arm64.tar.gz";
        hash = "sha512-xNK7R9HcxbqHww7mqwYxZd9alQ92nXduUOsYsuJxJVRCSOLcEXYmjzg6xZw38AHslz8pOO4Z8ABinlFsrJGGIg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-osx-x64.tar.gz";
        hash = "sha512-+f7bIijcvrKIRRuyUmNEO5CU1nJZ5ZhCjZl5zVKHNqRLd1/H+8ClTYxU2WDjUt/zAuSY4elYjkoBqMhtqC0g6A==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.29";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-linux-arm.tar.gz";
        hash = "sha512-SyQTMY/S2V0G+jNAfU0kSdnuEq/6pNtJQf2RY5fgKRWbMAjZoTpi4OuqaV/RI4maDxFx3aFIDJXirbOpc/3ZXQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-linux-arm64.tar.gz";
        hash = "sha512-LhnAKtGNtYPInwT8Y/OENhFMduY0bY73doVLCI6G9X2+81NZCwc7Ekh3coH4SxvHXMOikxKJKH8Ew5LbnpktgQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-linux-x64.tar.gz";
        hash = "sha512-Jzmkj17IFzjQU3b3vyay78UpdjnbP0dItFjVS/eVoITFvUeIZEm5mW6xozcbuMOQDXIEno8BUNClrIIw7zimXg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-linux-musl-arm.tar.gz";
        hash = "sha512-y++Crv33tPTViAFDmFCZF8MhFSVXOY/b7c4pW+q0ZdPEB9oPPfhi251lWqkVjvTYqdJcsanYwLoS4bLsOvBc7Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-linux-musl-arm64.tar.gz";
        hash = "sha512-RVTgpkZ4RH3xFMaUO3zVWwmLTyhLI8Rch+WnFiYiW2V/zSA73gcOQDufX9LZfVdyEv14kAZ+Im5T/AUE+ov5cQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-linux-musl-x64.tar.gz";
        hash = "sha512-uY8ga8KGvm6E324J5CPfQSbPcdckAZRDC0uN/ql/2wHtdZB5Xu9IOiNRaDk3khcdQ8SEHGhUG+Ti5+X8jDlSPg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-osx-arm64.tar.gz";
        hash = "sha512-5gopv+k2ori/5mjlI2TOZD6a6mZ6MMHs8zb+FBhpfoUgiVhTibo3mQvRZ/VzdgyFlY61oRra9pYKToEmI7vP5g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-osx-x64.tar.gz";
        hash = "sha512-oxI/M8NiWERnsPsuUAPx5JOiwBHoGgCvbgW+k20ya6X+9wwU1gJujLaPXnE9LeJY4xVsumDg3lU+Sb0Y3Wt82w==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.423";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.423/dotnet-sdk-8.0.423-linux-arm.tar.gz";
        hash = "sha512-2OSZoVIdCpFFD1a3sZPjqd5zV3WVD6tq7fUBjJ3Xjw+LAge+xDulX5534ofdCXUm1diN5HAbqMlk2zLSe8tnDw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.423/dotnet-sdk-8.0.423-linux-arm64.tar.gz";
        hash = "sha512-jG3TNaj6Y4Sa9VH+bxDKjpLbCxqqdhcn49mX1+v+vmjZ/czdJBoYBPaBIFV3CwCkBkjzLmnxYG7PhkRAkCxnoQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.423/dotnet-sdk-8.0.423-linux-x64.tar.gz";
        hash = "sha512-6UUT3+QicahfAeh71CcqqAtOwTVW9FMXVIAlQiJWZ3dSQsXigalIN9rmzGX3vMRX0vZj8kDA4rdXP9kJ54axpQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.423/dotnet-sdk-8.0.423-linux-musl-arm.tar.gz";
        hash = "sha512-SvnVGrLROW3sO2d+40rnS9yVcBPTGfRJKYmmZcQG8CRDcmhK2qNQnsIH5/OJQnhoG+HYymthF1/+v30i9KiqLw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.423/dotnet-sdk-8.0.423-linux-musl-arm64.tar.gz";
        hash = "sha512-d/Vk/fOesRrOFQ8SJ/DTGOPi76srbzHG0t20UE1TrgsAhHEq+i5hU6YCVDypx7kV2/eVSzThRyuyJRxBztNP0g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.423/dotnet-sdk-8.0.423-linux-musl-x64.tar.gz";
        hash = "sha512-QLQtvUMN495HQepr861ilyKuOJHxawdJljqIZv3svSUu2q/ZOGe1LCTb9L7ARR0a416CszaaxEyW7OIvlSi5TQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.423/dotnet-sdk-8.0.423-osx-arm64.tar.gz";
        hash = "sha512-qrfs9A5sjyXgvvLpxZfX2BDMMEgCtH3PXMcsSZP30tPJQJUSR9h7KnB8mdlF8LLn26bt4MbwLCnCA/zFOzbNMg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.423/dotnet-sdk-8.0.423-osx-x64.tar.gz";
        hash = "sha512-RKebd94MGYM7tWmy6O+6HNrI8aWD6zEMbBPbUeaR45pEze1r8yBgo0XZYwX8Zfd/36F1RIkYp4vjiHB/0aExYA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.129";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-linux-arm.tar.gz";
        hash = "sha512-s0UgWiixp8ELlzgDSEFUd8VVb8J9isYn4vzhWunQwOB+k3//j88XknetfvEEyW/5bVKpKLXx8+uw2sOk9EdD3A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-linux-arm64.tar.gz";
        hash = "sha512-Wwbe7Z4otLzO38nAh5l0t+2RRq60Rcov6mw+R6cRqJjTFAFA7SV/at+BXQIN1ArOnXfTkm8JWvFOkMIsTdfUeQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-linux-x64.tar.gz";
        hash = "sha512-KaliC5RQp1RxSMnVQx/iWsC3NsPyAD/LJRK2cz774aZsUgHGrPR/i7I2HXz/MpOfEOmR0rjL3YM/ezOsmeNFxw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-linux-musl-arm.tar.gz";
        hash = "sha512-B2paa81blclBHUvFGK4/zXaGo3HL23VZDxDP40EnMs2qMkGxT6Jl+nhSJjiflzTi38elZ7HUAKDdlv4tylZODw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-linux-musl-arm64.tar.gz";
        hash = "sha512-pejyFkaMU9OxEkjzZwlkB7bcUQQS8mRzcNgy6s+3crb2RnV4i44U7W0ZZZw8j0YcTAA2DTXqSeIK0qcMHlKmtw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-linux-musl-x64.tar.gz";
        hash = "sha512-4vA9AjMnI2UveLalrLTr6QibvCmdeDmHrRV85fEfQJco8L0vPrTliSrIKdI2Z8xMc/GkJJaNdSEwbjXsFZVORg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-osx-arm64.tar.gz";
        hash = "sha512-XwhsJkWnt8nUOlwWtjF3jwqUwQ4dRdsTys3hzqfxJD6Na6mZjlFbf5ChpMj+mBzTlRNM86wwUsVlJBAm9sw6lQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-osx-x64.tar.gz";
        hash = "sha512-feX9GZrGOJtYqoTDT7Hch33QLUz1LlhVp9rvhhDIzYUXJXHTI4gjnvwROGP13+Ro+Yu7egTZ7vimADY8+aGnZA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
