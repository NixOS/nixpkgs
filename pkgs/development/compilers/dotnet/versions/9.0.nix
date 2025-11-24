{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.11";
      hash = "sha512-CRF6VNAp0hvnR+eaIcyun0VDhAFOmMJgRrq5C+g3p/FCNO2sAmjGp0cPIa3zRaZL1bw18g9MhqVV/sFzUsjAGA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.11";
      hash = "sha512-1JPjeL18VHIjQmakba/P0yoAFdm/AjeHDU7RJUoJ4AWPjxFoexa+8+JLPF+aoy/JXzdysim5IyrHREEfYn3Nsw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.11";
      hash = "sha512-Nsnr3RYpZst0MEe3fEz88y9uX7yOlBSgiV1QMkVmB5NIzOwlkH3mq65oV6ILpnznrQRpTNLNnBy014CIB2rqNw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.11";
      hash = "sha512-gj9+AkWSZcmn/t79iHYVlRidy1gjJquiwnEHJwd01igi6STYIsuUHKlNL1QqraonBtVbo/cwCud8aSN4v8jQ3Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.11";
      hash = "sha512-agNcCSp6KndtdjAKzC7uBkZRLQuVjPKLoa8lgnWE61QLnthODtIN3ylyIpG/Ds+lUg37NBcIXC6gQdu7E6/VAA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.11";
        hash = "sha512-sPO0fwEfE3cmEJoRuU0eMdeK0U6svvMsqPuDXx304ljMkUyS/HIE5n3UuPqzZxmIlTmyYHty/SvA/KMYoaLH3w==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.11";
        hash = "sha512-Rwq64ZLgoMv5oQON3qtGG8hl65+f1YWusPDf8Ly/knAEEtQxYDJldLNu867igKPPVTM21v0cjMkzz/YoaA/CJA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.11";
        hash = "sha512-mp1jwpSKd+l/9/10sd/TgWwi/47U4j84Gq+opdUnVJmjdsRk+yTBokyfK7UsoENM/0htDxyZO3le7puH6DdOew==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.11";
        hash = "sha512-6gnjyWFxfYhqFOR2b4zr0OAiI7z6TI98k6P3ojpeJ9PzlY5HiCwb/XtMoyUxsIz0u3y5iL9kA/DBdMfcdjz8jw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.11";
        hash = "sha512-133VD7s2edW9CNuOJyKyc4nCM9L7yOSu9zbisBxjgtwBBKH5D2lNddIfxnZ4VkJeEDFBX/jar7d8aYHhZo8VDw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.11";
        hash = "sha512-OSHzPBEug0540h53udcXXYJVXiEjHBUXTzKssqEfS+c1+NWJP5251nN24fNEeY/FoxwRY9TVXQ0qQOZgEP6EwQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.11";
        hash = "sha512-VK+m9MiuLFi53lqCcMH152L3ydzxngTNIPDOwStoFXkEbtraMjkqS5D/tej8HH7zDO0k686UqrulXPXDZX4xaQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.11";
        hash = "sha512-ZAJjYP0LiASdxT58mGTQ1e0NpUdw3b1sHU2sRD6m1QPf1bkz6kf+FUSWrqMNx/EF/YDPVnqiY0XdOaHlfynmUQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.11";
        hash = "sha512-1E8Yktu8QmzO1ZYpYrycIuyCt1RgbYOVZq5fFY8i997ZlyQiAojabs8QzX7ew+4zmyytKlS0WJ0DNf7ICdbBjA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.11";
        hash = "sha512-8C4gsaUg4mk1bUnvLV9Ye1cXQwMLaov0YEjlGDoXdtN+GeIl6nYNZL0y8tud5zhR3BAeYJq3bDw9ItKekx1dFw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.11";
        hash = "sha512-BHwWHhcpSJTZ3Pk6zNi0vYCwZsPVCgdc+pB3UwS78LUojympjXU1q57pkueX+FpotARpsdFo10Z5M+gVo6K9nQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.11";
        hash = "sha512-j8ZzHU0TB3z+89skZcN60YN894NUE29DedsHDLjMI5vajloZSRKWjrDNrAtRYcJQHsn/RfY/vOlirrhkG5nNmQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.11";
        hash = "sha512-S27UUeuIua38OYbZ3u5c87vD/1H5dP2lI3WdbQew/klmF956/Mu8IfyQv8Cdj6WNFx+Rqf29uh72jyiWGAtSMg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.11";
        hash = "sha512-x97FYHDTVzHVroRs+f6eoSrHExDxNyRT6qMFoq1q11Hw4acO4cb19rXHAIOAmU1dNXY0PTT/XRI3jKrtCWC7aQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.11";
        hash = "sha512-/mHjlEznpNlIu4Y7QxV4flaM69jBfIwxYqsjcE63ROTChrsTCHTEntdOE8EV7KoeG5s9WNzIEUbP9a+I4aay1Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.11";
        hash = "sha512-FT+7+edjauTSsplgWPCiYyB9EGMvSd3+YVrsXeKBw3ym5ewcb3bnAaQDP/EPEjo6YPlGO6kEzZneBlhfuloqdg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.11";
        hash = "sha512-SEjSEcsqVVZybb7oWMYGMUizCmgCc5I5LxmqTR8wTmPzvbqDUkNJKjUwFdBi1qZeunyCBvyhgjpCZ4ZTVzf7Tg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.11";
        hash = "sha512-ocUPwvvfud3gR584qlx8Y8Rd62xB4EdYoYMgos2ArLfA7hg7BZ9ZXY6tISQ0raabvU5azEzi9tB6QbDftqgn+g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.11";
        hash = "sha512-Jba9TpDXtfkm6L9kEltZBVXDLMWgPqmW4LIzdPkcRVu/qVvdMPlA68eJMlunpSbM5pUuHQmDo03aumXXfbcSgw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.11";
        hash = "sha512-Mh69sMiLzz2K4Ag9paencVaMP9A7I9qFwLTvLGbmRcDwJgfpPxJ+rrs2iRXeV+9jIbJhamqHnfd2/+U8fU/4iA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.11";
        hash = "sha512-ayWBI19tajD5RH1LuRDi99D+21zRPozAxHrQx9Debyhj+BdAsruzxWj4t1rUMIXpTjWJFFm/mXhHFjZz2IwBqg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.11";
        hash = "sha512-umixX4NsQSFKfk/f/HrtW/ngDSMkKgWToVWAm/eGkarV3suBHu/71odru/pZnWuZOcBctXYNfbF4QoWwvXWGyg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-+EkCR+sTe8MHQCPd+sPcUyB9rFhI1hRCr5ZzDmoZN52+afuF2VsfXqVWnTPTwerVds/aTcSiHS+kgc5uzuA7aQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.11";
        hash = "sha512-Q9JERsVLgf3y5fZwuVGpiPoY4+mA83SnTD8Envad2LJh/mw2nUeuUAZzM7fJ84rbgG2eQjOYoIZo0aAYF4YbNA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.11";
        hash = "sha512-4LdEiaT3oaEH+UenvdmKQIXsWLe6gnVJjTfM9jdlNMHRKMFRD40y0Zob/u3AGwA/0pIXN4R6apjMcI0E3pcfGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.11";
        hash = "sha512-iqsE+bsa27DD7PZRjzLM7vUqy8HLW5+Xk8euyAm0Dy9eDf4E/K2Pvc7b2ItRq5vWpZtATQ+h415x8vzvJO7sqQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-1fCovRepCdCyo3BIiWIsGkvEOn8w8jZ6uCMG3/23NNSwJNqfGPTmfJTsTnHzBazL0mD/g5b6BUUXevlOfaQ8yQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.11";
        hash = "sha512-FWU4HzsFWjZ3mcMuypukRNesbWeQiLf+L0gDS9/3sTNULxIXcbZxhxzluxUo4Tf4E1KgX/G6LQ7e22Zqj+zzxA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.11";
        hash = "sha512-28Wq7LU/G/EDkgAuZ+lo3j+oDtBqeqtZs3rMaPq9nxK/ZIy7MeRKYnpFMjZE/oRyD7bR/U/W59DORceHZhhg9Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.11";
        hash = "sha512-ZF0owf6mTc3kwiLRXiub/WmmPw5LRo8JnhsMhSD834imRNSHPFm7vY5qqz3L09S2/loO9Jg2qAmVLNTQO8jQiw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-wEhZCRulbrBM/VuIiBNT+dDZ7TwrNqNFP5dQexpsTYVWZWMAitNpRPNJpbl0E+Md2D0sWgUW5PI28j3yO0rRrw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.11";
        hash = "sha512-rnqSCdRIQklHsCJOpzCGH3BpbtSV8CrgYnlTItOix7FSmkEhAZnuKYB6Pb5cewnOQ6GQRy+ThbfcPSanZ7jInw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.11";
        hash = "sha512-DWC2U/3MgRURlTuBaaxmqTLYl/c4AlmvFXsWEmpNzkicitDcr11IC3bGydlrY5I9f4Fe1RM8AAeJjs/S5MScXg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.11";
        hash = "sha512-tcIhpMXIgOp5DJ5ZoH3cPigWByQ24OmJRiT8ariDLWgmdKF/NMzqutLwbTQoJcseCfKpbv65hJgmQG0T1F8XXg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-a0h2VZPyFi9eOLanrrl6IyojwOZvDMM4gbKskh4VSC8oTeb5wvRGBQ57dZt9bNmQ8V9zbwKF7j3DS0Vp/gYwTA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.11";
        hash = "sha512-1lxdGgQKsmeV5UxN9ECaABM8F8Njk5CiMjetl9WwmDh7TX/nxq1W+cxkG+P6kmwIv82tN2sMtsgOU5Wz5VPSRA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.11";
        hash = "sha512-cS98eJh6ZqQjXMK7RJxzLX7lCnizepW+VAfsSphskxDzApEErWVFbQt3AaWvT9xTliFQee5IwdbFXeebw0m2bQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.11";
        hash = "sha512-iR1nN/h7z6gMeiBCgSKIo1nfvzdngqMmnjsz9B7MuP8d1x4Kvio/g5h/0c2f87waHnYVRTKxpJFSZq+6rAEK2w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-CPL1ka6MeJ2vIxETKShpFIijcMYP/6c19E6+UTri5rsfC9EmgT9iEqu64vM2du4opirIM8L8hxCXH2zt5dggNw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.11";
        hash = "sha512-0EhYJEF/++5Mt5bziEgyq9B1HsoaCu4xF1NxXZJa3oGSrLfqBgMWjYU11chevP/uGvmjyr3wBfNiBB4Vm2Iyiw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.11";
        hash = "sha512-JkxPEBV1BW93F4lniXE990FIbBrPg1F3rSH1Yb3kLQ2iHuKvcv/WjzMhzV4+IoAlqDhnmhJEnluWbgb5ETKisA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.11";
        hash = "sha512-d/whdxvgbHeynVOEYf+WAo35kQCmOdc3CYUMp4Q4hAd4lGvnCewrMaV5+UIELlglepOBvfqy2dCN/vWY477aBw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-I0bb0akGO5Xa1vDHLJIaE4EzAX7IB8++YLyda5HOXw9clqgk0IIk0/o/je1VRrKvnrkAKiViCMBOyg9T1ZwxFg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.11";
        hash = "sha512-txvXWXuHyahbrvLafRDfrbCtBxSoQb2Diedtj8RzXbAoAmENppr+jJNSuRXhSGDM/3jzriuDTDB8kUcq50vO1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.11";
        hash = "sha512-UaZc8HBLlASGS0IKJnUXRrxpskqmSkoGNLcl74yvz1+xH1bCzl4qnnsZNiH7VqL7eZjim2m/8/xuhV+ZClaFbg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.11";
        hash = "sha512-IFe222iEQqaTxtTmwI5BUBW2bdpAcy6Qq36+H/ETkrKk6op1qpwdr2TfPb7rFbZZcf2haK0tIT9+Fu7WGclONA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-kctJ6Ls5UDwyMLbSd+ANYcoMCDpB/aG+urcWYRXP4jHoEpY+hUjqU4hT6oszGNlCK2GnQyJA7fN822pJmL07KA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.11";
        hash = "sha512-Urlc8cO6rXiNlrO+0b8cOKzg16Mhfd5gHjR1qilwldtHrcTjiVEJlqO2KKXIYq7gA5roTDmaSka9szcOQQ13BA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.11";
        hash = "sha512-j/+m2g9tPOao+UqxSY1NPkWODOsQmmUt81QC0jVDVuSFLFJyoJx7/ThsnhhFL751e6k9QZew0Rf0+HyjJuXeZA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.11";
        hash = "sha512-q6cTfu+fFREFj+LlTeyfB+Z/xvhqWtg8sdbKgTq7y5xbVS2vrlRY6cCgM4EiwWbbyTRSBEOGHgwNBU+WxO65GA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-pfb+VAJ5OVGCqawLtZZZ0q5SLVrzxD7Yk4LurKOVb8S3rELAF/H8sSLkYni1ee5X3uVtdOk98n9DExfblDAnEA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.11";
        hash = "sha512-bhmiOnK+qB1w4tOiLNioglZuB9qi4I3jCPsyMQGWA1h/jLzhG6p/DxG+yYaYs+ThAlwNhN9qTtRFPJTerZbL0w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.11";
        hash = "sha512-zTmImp8BijWCiTQa2CPxpAafRri4Eofky1tGmcyagMvmjWXtLo9wY/ZHQjLuRfPR4dsxjwd+AaykP2ILM+dDTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.11";
        hash = "sha512-gRkhkGUQjQWkO3ACuqfkJHteFXQKCaDhUiIVgibcyOoVRGfhhw5dr2g3EwNdyAubNb3IxGFRMNCwtusxYiEOag==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-eqVnpgqXkHLZRTyLgm4FW5AljmoZwX4BEouDOjjcUHpd0Fo6pUtwgGgyDAEG5lCqfvuanJ+jiH4pE07aNE4lzQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.11";
        hash = "sha512-xLeiib6LB6MmvzOVQdxlBjvHHDkX+iHSS9kq5o/Xy9isJtyBVpcjEzLFzeisOtYam4LKEUiu6rYE8JvGOkpIYg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.11";
        hash = "sha512-Sh1k/KAb564wykG5wVaNvWojC0grXQ9aWty5YOAQrf6/RgsWWBVmdIb59Z3sc1zH9XDyMKY8METoJB11r1fhqA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.11";
        hash = "sha512-LyIBEurBS6+AI4Re9jPIm9s0UG15JSYZIzL3x74M0Sxl8YuXIXb9QoWH6VYVVaPR0Rb+rPZioIBLaUhd2J2kvw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-ACjEZaO6Q8t86NoZAf5Xx+eItzvUMX89zExck+SNfnrja+/0xPyzpp2FyxmZMkfEq+VPVoiYVyL15WA8lzziuw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.11";
        hash = "sha512-+fhVP/FEFe7OgaRpFSMIEWSBh2CovMusUoPIyMG/Q90VH5u897NTyCKKvwwvc4SX6bBCFhNGRGFTD2mAp5i72g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.11";
        hash = "sha512-7L9TubPc05Z19HVu4Nwxockx6U1tx9iJU1+KdsmAcD1rVIxeQm1lEGCZfxGOArWmKV1KSGCsLrfom7MLY90qQQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.11";
        hash = "sha512-rqLW2gtp0YaH3oHhJpGZx36UAQXMqGs5Y19esAOFytaS37xdrlPx7Z2fmblSBATyzpbPcyOF8qhgsUgSqSGwGg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.11";
        hash = "sha512-6Wj66Rgdg3SlSTBDK7VVlkqFPWA7JD9c6gZk0C4+rCl93bIxQny1Ye/p4N06xI6E0fFoDBew+ONP2TcapWehbQ==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.11";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.11";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.11/aspnetcore-runtime-9.0.11-linux-arm.tar.gz";
        hash = "sha512-HhHTG1SFCKRQPDgojLz9FRik/wnyC9lS1LDQChD7Sveg5MT0NSbWyDpVTjyXbDR4z6Jpbm7kmu8SI9MOi/dYrQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.11/aspnetcore-runtime-9.0.11-linux-arm64.tar.gz";
        hash = "sha512-vPZqVveAtyD2Y+Tyduu//rH4EXUj0Z/hLFRcU/kpzhA2cQugePMBl2fM0Z6RXcRX1g2tQm+SawvkbO90wBFD6A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.11/aspnetcore-runtime-9.0.11-linux-x64.tar.gz";
        hash = "sha512-CjxqIN0rAJKM0irKDJnR3dNrqT6ZCaFQl7lStUCX4LgXRU23vq5IKoldGHfCgSGP/+4PPwf2oMvlIeTDnNpdSg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.11/aspnetcore-runtime-9.0.11-linux-musl-arm.tar.gz";
        hash = "sha512-nPXPLkDKy5mF97RH/irFDXrJsm9oX2lLYQFrwzDpv2Wcg4OiGOeHS89BNCdyMwlXKmGmFBR+R6QkRu/4vTtvmg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.11/aspnetcore-runtime-9.0.11-linux-musl-arm64.tar.gz";
        hash = "sha512-Ui4mcOzU5S2qjd6r1x0uIixDYpkSVWwAiHq3oLzyR0cnYBpHxFSDfiJkHRDHSg8yqS9RSVxoT1Zz9qtL7RxKGw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.11/aspnetcore-runtime-9.0.11-linux-musl-x64.tar.gz";
        hash = "sha512-gDQzohTjbqB2umss6AjJcsDAIYWBr8dDkCEDe3JY4/yQFoPwp3pr/zbA+H7zeCHCeHz99cxLfO5xF5UqCguOYw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.11/aspnetcore-runtime-9.0.11-osx-arm64.tar.gz";
        hash = "sha512-XbTT34wE7JYz5hpqxPGjIakXFTGGLaAabf8jcSK5qJ3tqhg3NVMy2fEutshxJtjvBwlPQkiMGkFmHtcN9pEPkg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.11/aspnetcore-runtime-9.0.11-osx-x64.tar.gz";
        hash = "sha512-giz5gSktWfS4UUMImKdaaJm/i38LanyP5OhqFIREqC9BsIQ25Ijd8C6gjD+1/gROFliyUq6vGkmo5MuOCgphQA==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.11";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.11/dotnet-runtime-9.0.11-linux-arm.tar.gz";
        hash = "sha512-C3hiYct5a8Ld+nkQRXh6kHYhEjR3dibza2uryY4zQjs4UOzYQ5ByBf7INPJM3Yysi3V3Rdzs5KWhxWUUcUImBQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.11/dotnet-runtime-9.0.11-linux-arm64.tar.gz";
        hash = "sha512-KETL/6eO4rPFdWCTfjL+tDo7HwJXlTT+vwc97EeetOoPx/16U41scoozU7X7iOAm68s/8OBcEGNp1RzMJOr0GQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.11/dotnet-runtime-9.0.11-linux-x64.tar.gz";
        hash = "sha512-+rR/Puz1VfkTQn0wuNyfNHNV1nUQeJynUbFH3PPU3AQO5MQCZ9HGqjppbwc+VkNNbR/M4SmhI0k86QItwgTcFA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.11/dotnet-runtime-9.0.11-linux-musl-arm.tar.gz";
        hash = "sha512-JorBXOPB4xFdQNXp5aL12ODJW+4DQPzH8iY59xkbAFFsuglczGBo+PzzXHEs4QVZJrtnXw+lzKRb1M5ok6G/fw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.11/dotnet-runtime-9.0.11-linux-musl-arm64.tar.gz";
        hash = "sha512-xfY8leBdJRyu7MU0dqrTYgTMN9re9O7myMQLOOGrM8FQ7pI4RMKPEcugOn/fX0JtiMzywR4oTDqqCrI4DjSuTA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.11/dotnet-runtime-9.0.11-linux-musl-x64.tar.gz";
        hash = "sha512-i39oceqmmfDoSePRPa4bPLOpTRvWDtUjXrRwALJpueTsG0+jaN4TWt4sGZji+hAfPaV64QBlZ4O3XC+rsdwz9g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.11/dotnet-runtime-9.0.11-osx-arm64.tar.gz";
        hash = "sha512-5DbnC2x3TC8W/vm9I/skXM0dC5u/wCS64WTYit31+4MbFfpZKKnx1FIlK0v84PhngTfz9saAkzngOWmfupq/Wg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.11/dotnet-runtime-9.0.11-osx-x64.tar.gz";
        hash = "sha512-auW4gEbi+aIXJMpDz72UV3sG/EjxhpRk2KtMhh1j2PmY2ZArgR7aCyzuuw7FMNwii+s5/3jfloHRygiSyyBdoA==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.307";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.307/dotnet-sdk-9.0.307-linux-arm.tar.gz";
        hash = "sha512-zda8G93uT68VB+E9bbPk6TrLBf4rn7eh9uXOTuz2OylTMwWTPtUDhuh5Rf3Uybr2KR32OjGvi9mbadIs++uJCQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.307/dotnet-sdk-9.0.307-linux-arm64.tar.gz";
        hash = "sha512-Rr+wvT6BJPD6vdI0vPIDg6hkWdVfPT1zF4oLziiLQLgsXf0XJYa+RHUg4hH9z9qGkCyxBrXsxNMVI02cj4vLcA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.307/dotnet-sdk-9.0.307-linux-x64.tar.gz";
        hash = "sha512-/MF4rAAmz+oes3Mg+yX/0y5rwrHUjAkfYIW4ihXyQIDa4qMyNDxRyiQh9hPV96veiYNGWJ9JWfHlHWGcIkfSFg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.307/dotnet-sdk-9.0.307-linux-musl-arm.tar.gz";
        hash = "sha512-sKtwAvYOqUtoFAXEh2yxUtZckUH0QMrO+MzG09LovW7tBC4cp1W7gs9Apjzhm+JUUEKzrysh+KkeBaumgh5XGQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.307/dotnet-sdk-9.0.307-linux-musl-arm64.tar.gz";
        hash = "sha512-iL/jBb+g4cHS7bhwEhnUpm/eeDzAQt/yAlKn7hvQp5Zo1MLbgnbv73VgGbZ0glgpkHOC8w0wGUDqLlxYff8JQg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.307/dotnet-sdk-9.0.307-linux-musl-x64.tar.gz";
        hash = "sha512-iqHqLRnQjvzxN28vg3bYovyC/Hef9vFQ4K7jBoqa+HAR7RWQJ2ty8E408wEK309Vbx1GYUKRdqTidZWSSGrN7A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.307/dotnet-sdk-9.0.307-osx-arm64.tar.gz";
        hash = "sha512-LSlLg23Yu0ihX6v/KQdruc6+V4Yp5ty+YMw7Lq8GBx6hl+Aw+lCxuXFMvHAwRWrOLDgPxWnhw+7R7IqqGLWIQg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.307/dotnet-sdk-9.0.307-osx-x64.tar.gz";
        hash = "sha512-05ZabtZ07zCJ7iJaopmIUmTQg0e+CotOwQN//xMWzLulIja2JZUNv3M+2UxYlobMHWrcMScejyMikEmVVd1h7g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.112";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.112/dotnet-sdk-9.0.112-linux-arm.tar.gz";
        hash = "sha512-EqwXmfCPBgEaqOBSkEQjdx8z+fJX3jpPcG+b1b34pA3RSobbtINBQAkWbdnCsVNE0jI3ISQ+KdJ2FabtSAnj9Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.112/dotnet-sdk-9.0.112-linux-arm64.tar.gz";
        hash = "sha512-qUTpN2ECgr+gns04Y2Gc6wsiA/L6RV8NnVHzXKyzxmRSqMTITSNwDjYYzpSRuPoMjC/J/IAgn0bbb0v/TYRnUg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.112/dotnet-sdk-9.0.112-linux-x64.tar.gz";
        hash = "sha512-gD/SqCmnEccRlFRkD6CieD+q9IXzVeDhuC0WqQbVJoWrEZ5r7FyE4dQE0NX3WhVhLIYqPcZjZ26l9Bys3wcGQA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.112/dotnet-sdk-9.0.112-linux-musl-arm.tar.gz";
        hash = "sha512-tJAgLJLhGfgY9/oowAk49qH9+4m7QFFBc6C5Mv5N/DrwiemW9qfZps0Uq5YYWTDcS4nlVyWA7cvgxNdoUmBRDw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.112/dotnet-sdk-9.0.112-linux-musl-arm64.tar.gz";
        hash = "sha512-YukZkU7Da/OLCfSGJfz9A/bY5FrSBqYigFtZ+fCd5AKzKDl8xDOROsCJdzB8hHwOL5AojI8r8pezp8E79NrVOg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.112/dotnet-sdk-9.0.112-linux-musl-x64.tar.gz";
        hash = "sha512-DA+XMyzKq50VfXmSeENl71rRgPcsqGZ1+tyWOOzDBY6T+YabixS0kMBrC8iVTv6AD1c+RRGGwSSiQMoNydS1JA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.112/dotnet-sdk-9.0.112-osx-arm64.tar.gz";
        hash = "sha512-AuJHJQeOq6Y/cjXNqe0hykYSJzjKAelGHVCSWVLGaRV3gXPJI8CxQ8SIkGX9iHOPocJ48VLMByAJQNc6ascSjg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.112/dotnet-sdk-9.0.112-osx-x64.tar.gz";
        hash = "sha512-ispANiwWu4DEp9ubZWTti5ZlJKNA9cUk1kLRTkEiQsDGKt4gvVjAOVogIDTI8Tt0bDuYoIeDyynlLGMu4aSbpg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
