{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.21";
      hash = "sha512-yc73wTdJLhG2sR1hMabTbHI19IcW+vXBoRTGj25j3TF6uvY4Ls6dfj/WKTKqnTr4QVIVTK75TowNolMw26f/pg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.21";
      hash = "sha512-cVO97DE1umgDuedYZl2zsMh9iU0/QrHuOAcuihG0bJ9knW4afskk6ZXxpy4tQyUiOpUxiPHZKAa4+EETnBgK9g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.21";
      hash = "sha512-IzcIXfFk6W8iqZLkywFuOXfBe21AQYPsLu/CPmRIPPWO4S7uNKz+NlsdTLqKlpCKuBeD2F6bAJAzWViim/RIfA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.21";
      hash = "sha512-+vwjvnsacecF5UA8QihAcKgBIibgaoa0SEp3lG+RXLHf/ueLFSgbixumrGYQ9ka+lcL2Quq6IVPBHruErp4mug==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.21";
      hash = "sha512-evORqy7uBpKFqK/RGKJbb/09HZJNxFgXMYKMbKLKW9jsdPnwStD1ClQQgb5JF15OEKPmQRFlow6Oh/v/VQ4nIQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.21";
      hash = "sha512-KLGjflueOy8ZeZswJB5FMjy++kZwCFGLZYXWjvWldx4cAMJixlaMEj29+pVNsIVCbSacCXaBQ0P+u93P2vjcuw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.21";
      hash = "sha512-sfsbiG5QRnauxXssJzserNwsodKBK1/RYdEHe9im/VLgiEjgxi5f/n9hf0wspWfezf/5suQXKqDkG8s02dqW5Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.21";
      hash = "sha512-d3n+cSysJGgejTvRfR3mS0EHNk++6i2TBM+C0lR7dOwNc7Jl9dkzak/Q3c0MQIIamncpkTE9YH7dP/JTy4Sy2Q==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.21";
        hash = "sha512-ljnJ91rhZhIHv/ChBk6tRSnJGy7NjOp1+ZJBeaHiJTbjyonVHh2R0VDtL3RB8yarfO77NTc8gIjltxHF/umK/w==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.21";
        hash = "sha512-PLnZveiP0RpmoHb3vd5Erx5mKjZgUtPLNEtbCHepo6Cw8j9s9ZzMtdGOsq3NRCqIYng0gjDrw0ANAajKB3yY/Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.21";
        hash = "sha512-C4boV1ip3hPK9UnOUm3r7nj05dukE9oFKxjkJZj8lbE7ynRgNsiXTtF0PDrz2erxSWEyf/msadiyw+d9nO+j2Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.21";
        hash = "sha512-lwURW6r9omeQXJB4bLWH7ax1x/QrEo0L0A/nG8HZlgwPSK+TPcSHS8XPNm8nsxT2G1rn40o9Od0h3LjB7N5UNw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.21";
        hash = "sha512-3vHIO915Y6yjKcux0yG4ivaGeKWaCQjcAhuZ3r+RddtlHyRx9D4GT7vwCYLvFtlGGzGljDHBF1NjaEZ+500Snw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.21";
        hash = "sha512-Mh4W3poMC73qhGA2vj0QpW4w8oBZ5ToRBL1ibMGIxDhnRFJLDXkGBnaemRP6fNU+grFhubpP/C7erqRD8M15Lg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.21";
        hash = "sha512-L3/tnjm7gVFOTP/5n1fINFFKOH9bqAtBZOEQAD8U9S+BQ090OwXftgKiZLL0rJM6/VpHllksxfwu+f+KjTRfOg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.21";
        hash = "sha512-lIVnO/LvjjXG2NvRYGdFxVbUGqfqTAHupEdBalJXRLd/JeLq60ZFLlgTLyn8yetgGWt/VnjiM/yI+DxWDlzynQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.21";
        hash = "sha512-Ip70xw7W9N3OokPJFW7pV9FK4uRqyXj7SS+lv3ZVuEklRv68yJkfGJz9uXdJ+ZECAHhtw4s/iqbx1Ty1bnGuHA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.21";
        hash = "sha512-WRhHr78NxzTNyvAm2B6bjVd702Kw53t5TagyX8rT4Z8wsjNOjPqWFQT1/lI3Ll7iM60jUBvDGgq3oa3koGIViA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.21";
        hash = "sha512-zvYJ94T1J2yUJ37dJE5tTurk4JS5QpuHdfq9xxbbVz/QDsvGLJ0K5OxTsaQ+yJAle/LLfWP8T6v6oIObAy0Y7Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.21";
        hash = "sha512-KKhqzmloJjacTe5Tx296G653jRNMq2rfF6vwHOGY2Jye5GxpAm7MghHLquRAS4V6VPPPWXdGX2z3S7IIR0EoBg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.21";
        hash = "sha512-9eu6hn8PWTwn2vHzhU/kz3V6GCpLh89QjW/Wh6n0E+Dq7qhLuv8YoSIKZ25pFI5b23+WiFK0XLhF3oFb61D4SA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.21";
        hash = "sha512-Fq/lDXetp5rif96K+tbHWXD83scAiuAhvOLuSfsJ0KVoc5tGk5wfGTo2pVLLjyOE8BZZlnMUgPKQ3WC/4KDplA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.21";
        hash = "sha512-+Iw4rhRUPmrXd1P5XuChvhWYBtuAN+eF3VMukhlddwMBY/bZX02yaM3nWw6ajptiI1mE6kLE19je0rnWnPXqQA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.21";
        hash = "sha512-xYYzikbH3aOorrGLknEi95+72Wm+rfUtjCbxearizy8f2hADy1IQaqTMdv/CyQX07tRa2Vr1byc/t2BW7dMMAQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.21";
        hash = "sha512-jh08n88+Mwq51iTcv6Fo/hZ1KrplfhStjeaVbnqsqCm/yXNNP1DuOtkpIRqGHu5NFERhiWCeJPDsrXycnT3iZA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.21";
        hash = "sha512-OXNvUh/icQk6aLVwrvkNsX1J4W639y9/eN2kepIcNaSe+qaQoRfZ3F2gSHKlr2b0TACH9cPLQkyanXtiDfWezw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.21";
        hash = "sha512-MwKTA97WfrP8o7Dlaw/nEpl9NJzC5R8DmXTroO3L4ItwkRkZTU0pLgl+cI+1g5qyfRPQ8Sdsd9FyWkWZNv8agg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.21";
        hash = "sha512-jqOX9Zyggx0i+UOca+UAMKDCKF9dDZICJR/IfPAMHwuwolkOSLC0piCsum376yaFdcD15lpAaw4M+5QuXOJ0HQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.21";
        hash = "sha512-i54n9r38yCc3XtJSm/X97C4i5bNtCuFPThP4Pz1soYztIenFk1Bp9h8GQC9L7wbl0cKgf1r3CI6vcoV7Tsqwww==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.21";
        hash = "sha512-SPprl0F7EXUjdUD6ScflmKB+rROmMvLh43rQA0Zv7n/IQ8Yisepejpecv0zkVk0BrsqRHDMldNACBISae20U1g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-50iIWmKNdW+8MdeiqoFZFeFP54Qpovg5FNxfjIsmz7b1SJh2DPPiQwqvVcAhiV2hHAc9ezz4vyI1ozAvJns+Lw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-4MHkWTS4hIecvhCJinvuA+OQZ/2gtURMBWU4RtGThiJcZEE8hSia8+y5J07pGiQsvs4gpyFq4XqkYut/uYtchw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-D6eQCi8Y5ghEoVd5W9cGdXuoHY5HEdXzxzAB1Osthxcfb+fSUNfia482xull2gdM4IIIF8kG6HsopMxLT6ExTg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-oQM3hrE2Ob1ovCPGe1CRlBpFb9owhwYjui+mmOrVqJraj6aZRANVNhtRUAmqOgMZSMNGNpIAeOnQmi7f7nbiWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.21";
        hash = "sha512-/a9sB9s9DdK5FEktAfR9bg2E+Jsfv6pXm1tiLBx4NuuCcDY6LI8l+YXtdnHelE/AeQCY4/+yifSzVmPGmnd2iw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.21";
        hash = "sha512-nP1x+umjfH6N/7JjHcnh54aa9kPu5dt8oeipjEml6lqH3dRPpyLtXdc7eeekGTMDX5QezQ/jhsQXTuecEtT2GA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.21";
        hash = "sha512-7q3rFhymaqofMRyBfsHl86W87YwsL3blst076CwXpwBm122673aWVxaI9JsPaUMR+6Cqju5UXYowq9NVcByGdg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.21";
        hash = "sha512-FmFVwR3zvNUJZSaCpvDTK3P8eK26T0/wpuApalPyX10PnBOruptBrtOAz9YHdmaqC/Hv/dOhksIQPkixH4zybw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-emEawWXpjWHfW14ZcIz2OGddug9lvdpUJJ3WmGh4TsvoDBj/LqgsPUb1UpwONnnY5YTec57Cz/t2RUUt8ZVNTA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-aP10MuOfgC3itaiF+ITqUihJhkYqoxqZltHfOBivSRlHr1Hwp5ZvmpwelQuGi4uE6/YplYp1U6KnanJV3fSdLg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-vHNMmGk4Pp0vCVTGsmZTmtNsK28rO+LvY6KAMgqgKoFQ7gVsEAi67dvxAuyPgSDio5fJImnSqfJfXSCKCuF5xQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-e7QK61BOpJKRpLUQaJ0VG5H/su1iKiiqZhH99KOL8e364L2KytAQXmWnzPP+OcvO5tCgPHx2y+OJAqZ05/vzyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.21";
        hash = "sha512-AcCrxXcOtA+XpsPqTOFonjDy+ZQU5xgKeWvj5WRhvmIWnWK7CITRnZm6jbWardjgUjz3MD3mIWGyJRATqzjpAg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.21";
        hash = "sha512-QCdXPdmM2syzSW0k/6RrdN2sHgtugQQh0LRTNV81FIkGZG6ycEB7oloqN0+QeLZ0tz62Cxy7Wgj9/Mp6Dm7SaA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.21";
        hash = "sha512-ADPTh/6mwvdezX5OJJDRO5q7Lq5YXFtGKxYlaC7WHspN4LuU0Y8F378G/M/G8Qo7GrPoi98GPELq8Rj45eygmA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.21";
        hash = "sha512-CMfwzQ9rZXwpSnGqB2igJBGv6USJSMImwQx4UFoEQvBkGjQ4G6uG2szVuiEGLLnZ8iPmUuBCxytGGkAPC/A+4Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-UlBBcWyhC02hXeLv9aDeHe9RxSk1yJFuKSxqiQSMs5R4zjDLZfkuy4I+e50r7nsAY91am4A7FWf/Vkvze2Qslw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-qzvhPznwQENQCyQlDp4O0kldzC5uXX96gxq3cyxLwbo1PiHwo7+vrnpcXkzO/vXuHa1pVuSsBxeMWaOZUbgklA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-lGDv0t414T1zC1Il5yEy8WVRGxU/km7Sqg29bfSYHW1ZlgmpI8NUPupaGBVy2rO/zFJ6cm4/QxfncRJXSLXFuA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-wY6FK/Tu2Vnj+mr869reUwey08evEVXF1scJgUmBKtWz47/Atk5QGzr+uqrPVzrD6R3UbedNYoHHMPi9bIHyew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.21";
        hash = "sha512-QMgaIfpuAaMSdaY0OO3+S6nEQbntWkeV9Ql408JRWXYLM0f0Utl4ZHfV3xPOllf7ZpW8ha8jZRyyJB/AH3el8g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.21";
        hash = "sha512-KREhQ36LS8yxeuzY67nA79mmAEAj1pyVLeC2Nk8eDhsNslG8+AB0uk5sESPPjJs8Wqpodh8WcrN1cw/SbKKKbg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.21";
        hash = "sha512-u55E0jcZgDMRmWlaFSUH6eCc9wNOiZjmM4lhVBZUaxyE5U9cAah7qLDnvm2urr0aPgCQgK8vaoXYqCqUHPAQVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.21";
        hash = "sha512-pv+XQeaGJbac+pR/0ghI7yFcGoMVAwJKTD1HP+R5883gNAsIknGiyxqxXh7zR3l8v4XBYtGKw6vp8AY5ndZZ0g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-9U1qOXMrzB+R8salrR88WndcFpqokrg59Cg5RJ+zhC8jdhMyS9HNG8pZQ0MvPbjP2YRkhH85wOaI8TyB+lXDdQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-XiRNdQ3vc8Z1VYUBp5pV2RT0KfR1f1dgSxjfTNf+R7VhWBjS5NTy9i8lcT7KEhFXV812l5WZuhSyhzIzMwFGXg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-zAXGV4WisaMmoXxiFz1DzJ5lfIq6y9FN39pG/MX3vY2RW9Uoq8qwEOf9s0xeDbvMXv4WKRwYX4dFYCfINYE0bw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-AFb14uH8CVruWu8grwr8vVIJiSQU9uHYfJNrFulAXdhBOqTETvjQ4Xjtv/e9ItDp4iW+uXjWhnYrxxrya/0C7w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.21";
        hash = "sha512-MbFNR6brjUMvFEBas+RCL1UKAjqZBZI9LyH74aRj084mX7AsfP2BOCQm7ZXjX+X0DaKTu0F6mNG/2MxYHcOvig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.21";
        hash = "sha512-QYfhB1YdIGvT1Nl095EqD/locaE8b/pior4CYT3lrPhMGvWuEKYPPdMFy4u4OOg6BhOScsWPdqFFEDxD9W1Q8A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.21";
        hash = "sha512-k667dPCRgvN1MEM37lkrrh97Y66LOW/JA3C8TkVnjctmK3WTHteZJk/x0mq7hH9ProeHfN7hwQXVCkocmgkJgQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-1TDAcZjWec0cM50aeYBubaOm8UJ6+0fyPGqPcz1CCCgjz3zJE9I9XKtBz0LCm2oHrAjLNC0x2qZFhFWteK/Emg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-+EfASoBXc1v7W+zJVuswjuCa0zJlqxjMPCfkpNSCyJ2fZbAAM+0vhTg4T0HlacRHPyH51qjeMmeBANbrhqNvPQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-6Y9ycNMabHRzTOcDNv7c9/eYP7WgRFuCvvS95brE5xAwRaUnbQ1k3u9lnHEb7OJ8+m/10MWNEPI+QECerL/x0w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-JYxEkLMnAkTunEb1qcG8W5XK/tf5jN5wsKZTqwQicoeU3OQ6doMne6ywrFSFFlLjSuEl8MQQZ6mVzmppzBaWRw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.21";
        hash = "sha512-q4DUdU6sjaZhO84ejcU21w8O+dv4hNyqiKUeEldZ9D/u4Rxm6CEW25omYHfYz8XCFNqpp0a3fkla4bWCHWuQXg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.21";
        hash = "sha512-Tlve5t81ruUovhh7/FS8sWtF/OvNtWfggg8IjIvgnwTr6trNf2VTM3dsT0rtZ5IjAhQUhOBT6ajZGnp6YdjVbw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.21";
        hash = "sha512-OlK1cQC4y2o01wRxvErpL4SOne+TkVQBKUNPANzPjRlwzf2SMjlJ/o2k63kvH86t5InqC9iU6acsHiKUTKkoOg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-ajadIF0no53b6fSakfgw84GrdDYYYyvcStsjlDJKSYKu/EvxsWDWFpJ433D4/ZdYHlaLKtL3Jz1xeXzoFvXa8g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-9xn3u4mOTzJEeWwmmAd8ESO/+RqS+6sScmoiin18l71hpbV3Rbd4Gxw8KE1TUN3ktw/x1yR/rqe8b+cKp/kk5A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-xdsmVry7Cl+d55Of4YAkPJ01zRD/E1DTNNHPTMViY2dPo9ljZUAycO5Lzx4lZ4fTTd8xAYTXoOiuEiPSACS2Mg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-TAiEEsZzznQrgueWciaRL15kqnpu75mSjG2OxVyylWcJEtuHaKmgkdbRRJfqr9LsiEbU6Xnz4bfoKwZnZRYJVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.21";
        hash = "sha512-O3b0F3/hyfXaWmxaN3VGPcSz6mR9RTTi6av62xNpQmK5+Ocv6d+Byj4cM7de6KKS0Zpp2Q9s5MOEX9hJNtnaEQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.21";
        hash = "sha512-xr6ey6MitYjPk1xl2+5ZraHGcaAzROh1EN7tVsrTijl2cR9JXlmX1tmOcz0QNWzBN+0O8tkmQU59mjwLjNNgYA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.21";
        hash = "sha512-DKM1H8a+WY+f513DrttnERzE854tUQEIXXLsQ6oLsFAZioKkkwZXq/IffIrRNLaF45/YHBInlxk9+onUhvC7LA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.21";
        hash = "sha512-eRbEBR44c/r59E/M/N5GfUBeE/+2GdtU1sr8rKBKhRLxkNIBASt9BD1zwCGc/JrryQhPtPM2CIsn66zfCCbBKw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-p4gs/KkZivZyWK3ik3OYlYVh7jaAMvhMRqRbrHRZuW4RVmm8IdIw+HXpa8GFys36aoFuW+PQIt33p54hfC+Fpg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-xhwn5InZvPG75p6lWHU7u5Bt2VEAq81XpIsNn51WOfhojLFE5oTCz8hz+S0bcyW3LEHugfWZc2hMYi3VCNlIrw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-fxgN/ePkeIF++8OIkufP/AoWsfLtOUB4E0P9BhHxKVtqBiZWerPPGRzbUheUDq/Kq2MKHsiJd3QNNwzoZLxLnw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-B45J6gG24MoBjgU6PVNQ8ldXVvcJmzn9GLfvnNHhkfhpKQ3VXUTrm5KuX2Z5LQHstxuwPPlsmPqKDp2DBEakeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.21";
        hash = "sha512-xgwd/3vSDlibBpY5XvDIjefOg6nEiH6o/24oRzZF7yk0FRq1yOBs9gxygkRp+c3/bYy5A2zQYnqYUMenPJ0t9w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.21";
        hash = "sha512-37s5nLcLfigZtsSMhoQXs7ILZw3lkXy07C93DOKGI1Z2OKdroPNWeBt1BpwAx3BoLrUsmJnXgS73grfJM29D+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.21";
        hash = "sha512-pqPuNmbFAXnF0nJL6imGmQQo/V0orIDe713lVbYEH1y4DfGL8ichPM1abCvY4WFb7gwaGHvqCsZkl/WAUde+kQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.21";
        hash = "sha512-xRiJayebcwD8lge6jK7mc3FB3F3XGUi3x97DAOIIPwWug3bmFA+bjq0o2+iGuI6cddeTIeV1wYeh7ONtdddfDg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-AvAKwP2a8yCZ00aOMgrudrNHF1csUnmOSqC4zVulg2GFAEYYqkyORbbPTpOdNqwHGVEoC7qPnVqtYVuzG0mIUg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-cwMLV5UbNKp2M9Ad75GFFmFT/HgUcNo3nUepMAkN33Bz9U/blqFgMcy6qJ47ySJKVyZ61avxyAGOWWQVlISTqQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-SkRaFeVA73rH788FwpLxR3MHX8LQ1ZRnax4wGtr8FVtY2p6/8P3vGk5aOekwI2ywwefrKVz7zNKXocSCB/7N0Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-zOU3NwZcpmz5Rilm9sp3RisEQrpat8V6ljtJq9t/6uwlkSciqtcHkXQ0W1Fh7+YbQmi0iPPbsA6sYN0tio6GPg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.21";
        hash = "sha512-zlyWDssdENXNvkLian87o6fzuzn9j5G1hWdc44HBRUREC3ydAZgKy/EevRh6Bd312VUdNkfRjB0heECYqcVNUA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.21";
        hash = "sha512-WaYQOOV9G1DYUYrLI+DqQAu2DSr3EeD8rC3yH5yykmfZ8EhiYT4LXWjCRQl/quBKEKgHqQ0KxY21Gzac6EbOYA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.21";
        hash = "sha512-aZf/AtZlfgr4nKm4v0aKlv6acDCo3EYKNYyRLeWdZXKRhfVuK+lDjp7rQSljFmdRyZLM4DdJG/YfMu63ya3eUQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.21";
        hash = "sha512-fVMu8WYT2ST0TaHuUtovoyrrLCT8B1WGxeUEJhPxeTE2yyFVL/0TTQ0zMV77lekRASl3yfBSex2jLm3qNNobvw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-iPmjDeyWH+VnS3J9P6e+j9EpKZGmb5HLKPLyz+MgCpiajgf29UEJBWpzxB2hwAMyYn5NksYsDFeOecg5NM1STg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-Nydz8ewNZn1IoHrKMXVN/SpDKSKxDeqeYF1rCwzdNaX0aKGjJ4w/mQChxcXCTALGcEQ977+NluxCnH1cl33ZQw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-ZFi4KULMjcxL8U5Swdn/KQSkrqWJAcv5oRXJefth41DbeJtI95xnJg99AXn1FNYLD5fdN6V3DpwJ3kWiVC5trw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-B5ahysmcyx8c8Hx2MaUlHLG9O9yc68r6IV0NGBHeuYoLjnZNcBMjAB32eX7hrsT3vZwJuCQV84Ah0D9pFJvRoA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.21";
        hash = "sha512-nTiRRAt5Aq/gYoVZ1rB06ELfJdBSzWkTgxfzpFdRoV6y45B4G3uGfv/PNbY85RVpUrubQSJ/b6o4dhQMsuJhEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.21";
        hash = "sha512-NU44IQfTUAxJPwuZnB/G/Lzy4dx6nRwzMdw/Z4+qeDrpwBILfm+J+UH5XlU2yMEfBqj/8G6TFfia+sjyBIC8ew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.21";
        hash = "sha512-TdynS3rFM9NS+9VPEsOvNxrAJkz66bX/GmOhMhr7Dlc1vQRwfsrac4jXEvNKa6P+yAcuphGuCjKMCHrMyKbcJw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-53iaTSx0gKFfNdQwbvxkTNgkZaDgwoySnDNNsIQxd7rdsCE/wjxNYBNBpxWauDyMiWhVLrULq8vOgUAUoYE7jA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-tuhQt6o+qTrvD2h7HeaL5qfL9vhEOmGGuYrokXLC+YqJAQEJLBmXf8I7BU8lUHUMNWsQuKIgS5OVGuI/fsX9Hw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-IdksTz02dZyEAkzjiJdnR3sJFLdo0BI+nZju0yRB1xZoJrmsJaH6ioKpS59bOSZages/Tsbu/E0KauMakdodWw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-C9zXOY66ASbVQOt4Fk2aK1Bo0a1GVNe8m2WP/aD36YAyWtNQuKf7ZZXxKK1G+9no2gbEIuuyfAKLvC2/YU3IWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.21";
        hash = "sha512-e/fOvEWkpAHmkvMHWzFNXO1Y92Pa2VsDbINPKNwuxg2PnM3vig1m7GRSeoMP6IZcJ7ROBAcSgrF33G8Sueh9hA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.21";
        hash = "sha512-BMkP2ksUWsXVMG2jPD6y6xBqJ+sZz/VScvpbarq9M+vgM8k0/ixuHADtJeI77NUiJnyubPlwi1RSOW0zPgK4Aw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.21";
        hash = "sha512-7R7KhOzVY47vFExDUuKd/KeuNzE/DslGw8yimHSqfwZ7WWK3qWzKMY2or2j3Wb2TwawzE/EWjnHo/v0oH2TGyg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.21";
        hash = "sha512-KhM0tkbgvN5nRw4smtbAjt0tmBAS54MwfC34h6mUJOalqYGZkQBiSqSr+W6GS5yDXsCJII90GaELIxrAjqdrHQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.21";
        hash = "sha512-9UlhDkmNcBdX6+nhcERW/pY5jlgsM5pBef7MG+bsVadQSBThhCc5K6tLSIu9dgA9+rqYyaEsUvUyipmFptXLpg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.21";
        hash = "sha512-dCsnjflmNTbNpSD0xs140+24j2cfSrhSADNfGTyVZ/dJyDXa8zx6ZEpXuKrKMLADtPZHGPkfPZrg/9t9M7bOsA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.21";
        hash = "sha512-zBV8AaqYLrZN2EMx8F4lN//kJewH1L63oIZCHj3c/gC+4ZPNdjxzYew2fNe81P/8cJxtDB5fwOY1Ss2iHC4Jgw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.21";
        hash = "sha512-Me1FCUj5ILgMnQDTYKLyYn1Un+xOxoh5v1xeZPJkGi5voe+8I+ydJsi5swoAU+SDaovEQBBkZiMmIOec5jA9Vg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.21";
        hash = "sha512-/g2qSSAS2KfcIaQfRfoyglYZRaGx7F/SoGPWjiwtoi0/kTjltgLAbcUO+iRj2HXK4AFoVUEQ+7s4HeNcwYggxg==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.21";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.21";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.21/aspnetcore-runtime-8.0.21-linux-arm.tar.gz";
        hash = "sha512-GGI79z8iNr4pPXRWtrGdC9r79Blx1C6NS4b6U2npM1EyQ2Zy5lb2MHqrWYQrsaIuRHNh13oY2lm3tw8QCNsLnQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.21/aspnetcore-runtime-8.0.21-linux-arm64.tar.gz";
        hash = "sha512-2wSwhcTOHXMuVb5X7+dxtL5Ma8+bU1n7+ImTsZAm135+EIpBqwxEfaEAMG34396QvJwgbO+xhW99prYYts7aMg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.21/aspnetcore-runtime-8.0.21-linux-x64.tar.gz";
        hash = "sha512-SqlFjT3ntP+WCtzEplXk1+TmVw6XeRkZETuMmlWIOWSmAkHa86cMYElM3hphFV2AIznsA7BGRm6sZymPCsxyiQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.21/aspnetcore-runtime-8.0.21-linux-musl-arm.tar.gz";
        hash = "sha512-MawjT0wEHz/EWy64GfZHfZIQgaVFIoSN5DgVkjDRYe9Cev9KBYJFlXu8DXfWMRp9O/X2PFzj3oxfN5Mfucu0sg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.21/aspnetcore-runtime-8.0.21-linux-musl-arm64.tar.gz";
        hash = "sha512-dinHqDFpcKY1RriIMd2ndlDyowdhXfQtc1x14pm5NewfUp8pMV5ETRb6SYM546r3uWGpGKye/mbevIq3nh+3Rg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.21/aspnetcore-runtime-8.0.21-linux-musl-x64.tar.gz";
        hash = "sha512-dPnb6yUl1q2+SauOU5aYYLL3ffOe/riA3YR5h651gy5EsRmiszmCjKFRaFo6tQQ7cBjMlkb/dw47wQhcRqT07Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.21/aspnetcore-runtime-8.0.21-osx-arm64.tar.gz";
        hash = "sha512-W2v1nXx1AqYZSUtaIEcJWgTkx71IYK497l/hnS6ltUEJvUzWZvGGYC1pLD8qBWEYHdSJp9oY5IQXsRsMciiG1Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.21/aspnetcore-runtime-8.0.21-osx-x64.tar.gz";
        hash = "sha512-HErHWsAt2YRVg96hDIIx3lgffHoyAHONWLdCYuCZiIPmI9tZuIeV+XJMwntG80RgbeWuK+8pCFaO5OyY2q1u1w==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.21";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.21/dotnet-runtime-8.0.21-linux-arm.tar.gz";
        hash = "sha512-8H2BCeRjn6X4qct94/RsrqWBbdZFn0gyh9i1HUB7lCbtWijdEbedqf3XZF7ERsz9YuY8aV/g4IOOslar+XGaUw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.21/dotnet-runtime-8.0.21-linux-arm64.tar.gz";
        hash = "sha512-fq6tvMoWmy/dK6B4wkK3ddF76Ifw4Fi5Nt1vhywberMmCmhS45i4T0yRZdD1W7D83r+LPeJv+YCrfTpD0yC9RQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.21/dotnet-runtime-8.0.21-linux-x64.tar.gz";
        hash = "sha512-tXcfmPiby3C6GN8jTdgvAG7jskH+SGNIXqZJ18Qo0S8uFN5iCk7An1a5uYtSFsWyFqR/C1zZARo4OZPu9peQFQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.21/dotnet-runtime-8.0.21-linux-musl-arm.tar.gz";
        hash = "sha512-5iizEWpoY76/71ACrC6EcIEOBo7h4iGasI5+YJRT6YDU3xkRXSU1Zgm3qZp8/FOAj98wr0K2snc6njRuGDXpzw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.21/dotnet-runtime-8.0.21-linux-musl-arm64.tar.gz";
        hash = "sha512-T7MSWfqLzCUJicDpBtUt+i/1ol8q3dOGeNeI7Sl9ug/lqUd/mwA7BqqvBap51mhM5de19JviGORyosxg+BL6fw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.21/dotnet-runtime-8.0.21-linux-musl-x64.tar.gz";
        hash = "sha512-hprd9TZogQTFOipcmzZUlZKvc+7Kv8xUNPMwRTIaSEC81BTs2MqTU75j1Oh5RecvI+0oenAlcBbSkZqod9ia0Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.21/dotnet-runtime-8.0.21-osx-arm64.tar.gz";
        hash = "sha512-2t8yeB7dhoPjxD4B8ZjbMNzciTG1Z2igR/vH1zalQsiYjBec8HSOdRzPq/EOTWH0Q9Q/K0a56tYK3tmbThbp4g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.21/dotnet-runtime-8.0.21-osx-x64.tar.gz";
        hash = "sha512-eDrVixiyGl9LfU3tFJ4sKlVLaQ7dEs45dFGqtaEBy5dKq0BI1ACrIW4VYjCeF6JyE18rZHl0Kj9J2A/2sjLnfg==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.415";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-linux-arm.tar.gz";
        hash = "sha512-zmtBU2PSefmkhDQ1J1H0AsBwgWqcLBZC9EnGsce967o7nIXvQ3Nknrdt8wlg/jlAWo6eEmBKDENXgWz7QhUY/g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-linux-arm64.tar.gz";
        hash = "sha512-wu/Mz9g2kEgtMxSyOp2bU9QVkXletQ4ChXy0ld0f3hMvLDMtwkMJVGMzjS3GzTYs1+p646nOdbMqtUpRe5He+A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-linux-x64.tar.gz";
        hash = "sha512-D8BJmoV/Fh98NXdbs/UKxvAzPwL13yHSEUfVOOsmqahygtS6NwcYHEbzwJ0izcmE53ggpZU6dzUl1vezMt638g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-linux-musl-arm.tar.gz";
        hash = "sha512-M2KT67QaYbYC9YAdw5olLCdAHrCcAa0vIpbT8/uGhQ7BsCfGTKb9LymoZrKl3bFGCVmQ+lBifHt18EGSfX9voQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-linux-musl-arm64.tar.gz";
        hash = "sha512-KBSfadUGbDMfjFrGkuxyJRybAH0eIwzigR6uWbBaQJhSmgRLpKbmvW1U1oTfNcvI214RZ0R31HzhFIsKiqzzSg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-linux-musl-x64.tar.gz";
        hash = "sha512-5vBcdSv9kNflPusoPYdB9UH1J0XLufv9azgMt6j902zeOCE5/FCqMHfmsCpvAIqtNrW1NGISS9e1lhGRb8K95A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-osx-arm64.tar.gz";
        hash = "sha512-P/Zx7ioFNalsX+3cbg4ljel51O3bgihHO/1LZWuleHLhE1cnZ7eKXh6UYmGSXH7KfbEVn+M3dgbuCrqL0QHcBw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-osx-x64.tar.gz";
        hash = "sha512-pemIo2kEQa1daLDu2KDe0YgBoj5fVsWEqpQFSQ8glxglTH7ibFsb5FrNQxiQYMw3ENJe8cIZJSpMFrbPe2+ZfQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.318";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.318/dotnet-sdk-8.0.318-linux-arm.tar.gz";
        hash = "sha512-1WMoeN8Rl8/oFfKUNQkwQE5AcZkoo0W8LV1mWfJOD92ctCPTL74qt62UItrNypG3+KIFHxcUIgrvmAfbhYziFQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.318/dotnet-sdk-8.0.318-linux-arm64.tar.gz";
        hash = "sha512-oxGu9CXmwok3R/2JX4AEtA/t1siq170ZAv0j5CpTcwlq75KDADavtrJaaALuSZBmqGnXqMvqT9grFUvHBpoJRA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.318/dotnet-sdk-8.0.318-linux-x64.tar.gz";
        hash = "sha512-Ay0dybsZJ3ewU3nO7CsGMNR3iZ9lkhqHRYER74q27nHQN4fWFWTCYnPnfdHJ6zTafXli6V2g/sRz/839Hvtxtw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.318/dotnet-sdk-8.0.318-linux-musl-arm.tar.gz";
        hash = "sha512-LXNOLl84jA8KInGAsHmGDAOxxokCBynGI0T/B5uCReHcKaQyGd5DgoVkw6+Xi7Kd5dVlbQbi/qTpUDC/Gls3OQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.318/dotnet-sdk-8.0.318-linux-musl-arm64.tar.gz";
        hash = "sha512-IYqpuqa2PJbRA9MLzleJsu6QlrrS093NPfch1f6Aq2+z/6Zs3TXIhlNOhbzEEdqRqhg8+EuV3+2zMmwx+8YKBQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.318/dotnet-sdk-8.0.318-linux-musl-x64.tar.gz";
        hash = "sha512-EltlbXltIMRy+Fj2MLcucusEw3igqNhlm8FD+mwEnxYOQlUKJ95TRBrZkBiA/V6Gw8AmAjfLGWB0LX2Q+w2z/A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.318/dotnet-sdk-8.0.318-osx-arm64.tar.gz";
        hash = "sha512-4mLam0wRJu0Dawl9E2A7cum2R1u8XOKEb1ubE1dqyCgFb6BzH6aIuoZOfEiRpuOT4qaVj6vwawBrTUTFBVQXlg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.318/dotnet-sdk-8.0.318-osx-x64.tar.gz";
        hash = "sha512-9PHLqLiKiANWCGQBRdqa+iDQzWiTyrfqS/Z42JZl9LbZK6ukx+KV0C/6uVAYicgCrbEVul61n/YwibAp+GwPJQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.121";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.121/dotnet-sdk-8.0.121-linux-arm.tar.gz";
        hash = "sha512-5xiXyifpLF7pXuNRg6kUKDhHB0k0soh1P6pPQ79ZNJZ/BCR36f1Kzmvz0oPpSOjDS8nAAwhQSTnA8z6kuAxMsw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.121/dotnet-sdk-8.0.121-linux-arm64.tar.gz";
        hash = "sha512-/vVvEX+bnOqOQa18MFfAk9/uUZIIxnR6VK39cbQLSsBoPAoNSj5sYGZBdDeAIrd7wxgSKQmjATaoPuMu6KqKZA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.121/dotnet-sdk-8.0.121-linux-x64.tar.gz";
        hash = "sha512-XzVUBmqfc4w6E32rqIXKbrZp8ehNU2zHBkhkghrMcSPzSeuiz12QwlKHg3nLxl6SFPZeAeJIL3bgPDXi08m5og==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.121/dotnet-sdk-8.0.121-linux-musl-arm.tar.gz";
        hash = "sha512-e6rW8lVKbUMqayrowSh8oKiIOoy160mvfK5V6DP4aVkQkpDYxvy2Pisl5qGoFWgPWSeBJ5qTnYl2Cb4zrV8adw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.121/dotnet-sdk-8.0.121-linux-musl-arm64.tar.gz";
        hash = "sha512-0EcEZTTZewI4hoXvzwjZaevYZx4AqTL/kMQyvvngG4ZfW8xRpqnIcgG9pWzYbsmy/tViaQvX7JMMrgT4co7RRw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.121/dotnet-sdk-8.0.121-linux-musl-x64.tar.gz";
        hash = "sha512-wnlpHCb1CuYhiVlpP+6/In19YcF5Bt1giDakgl7rRvw69ovDCyodOT4Bt7oRes4/sFnZfAusWQ5fbOyzCxbH/g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.121/dotnet-sdk-8.0.121-osx-arm64.tar.gz";
        hash = "sha512-hR8ajS+/chLw2d25zmZfZt+YAezBVBnPMlrZ7+A7uGrgmecTWxx+oX7V/5oU6ayGYDeGUXj3vvHkYUZbW6jFIA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.121/dotnet-sdk-8.0.121-osx-x64.tar.gz";
        hash = "sha512-X14oqsO9JyT2R5LAwj+cWl1e+Fd1HSR+t3+Fyui3h9qjFSt9jsTWt3ObtagDXwAVr0isR7E9p2ydxfNP8P03Sg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
