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
      version = "9.0.8";
      hash = "sha512-HSxwnf37OGRcVt9qq6zwaPoqnve6MXpwjq/gzTagXAJTM3AgYE7gtAzFKUPj2/yYLAgdHEi2y+7N4e6LJXJAQQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.8";
      hash = "sha512-14cuFcWzlQUTtNwpeVNCP0q9bUfdm0lXFGd8fP47uulSBIJlcvUmucas1BpSmB9ofsVC+jcmkLr7EvK/l2zCXQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.8";
      hash = "sha512-rXC+UlNcK0NDSKCc6NTc6KGlBSKXvu0hP/oamJ0+6mgETnlySbRimOOp9ZOipoXitRk7sXdWBQH7F4Jy1UEFyg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.8";
      hash = "sha512-LVju0J0eNHVvP8nQUmCiJIWTZrAo1TPoNRtMe4mB8WpqW+VzOHNkKNqycTCPxJ2ytN5DlQL055LtSLW7+lS/4Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.8";
      hash = "sha512-qa9R51SRJWc9SdEM3BGVEnV3AQm9rSQ6EjBELmcwE6mUymrLCSnHu3HcEh6BNtj3Jb1mk4i/mU1dWag/C+qdMg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.8";
        hash = "sha512-U7dmRLkAb8vAO0UlHXtPHsljYS8XRZW2GnTc/3KCvtnePTQvVaOwAr7iLyY5buPykg9Pd88wwzBBOtF/97mlsw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.8";
        hash = "sha512-N4tnUp+0xdKb/m0tmHBic2YKlO3oWluKGtf5nd3eRZmtUdHQOCOjwCZzzSG1TW4MMIBbtc0ul21CeDd3xTghCA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.8";
        hash = "sha512-01bVanORYWTIBcqg8SJfqVrWcadM/u9MYe6Y35fKjTm+S7nqmyXXxkJqsSW1nSiVTKLopIomBZU0vF6s6EHwXg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.8";
        hash = "sha512-4JvBQlwuNpWip4n/jOMirgb+KTq40S1dHcq5/nBmojKRMARUU/lJiUqdH85NRamUE5iJocNsndWMLuqfJg9BaA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.8";
        hash = "sha512-rRu/lQKiSzP5a0Jo0Y+gD6dF26ZeRXkJWoRwxYGmj1NowU3DedL4tidTdFSVDJJ7p8jGLRhDB6x+MjpE05QL+g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.8";
        hash = "sha512-vWcLP1paVt0v4fwHJB0GYYybIhfMFCiD/hdg7Vfnvm1kkNOARP88U9xfSMhYN/EBxMzG2Q29kI6e6vTMrXrVNg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.8";
        hash = "sha512-IkE1/clVa/ECX5w/hQy1Kt2BEMWjpmPhJJX/IDT6Igd7gckL4Funf31B7MJwGwmACF6uzGYSZHXM4GcyPYTyCw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.8";
        hash = "sha512-RiKfoTAn5AeGNBuAANq0Raz91lSkTXFc5xFVNW7Ff7Gtv5unLAVvGfP/xwQVZtLHhIcvmyWo20mYf2uScdk12A==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.8";
        hash = "sha512-dX1sfzQ+VMxakA/Q1g86LDpZdPAypT3GuYpd0HyzoFUoOMGS0KfQjBlG6Ujz6nGTrBR1627DB8o4UjrCtZO1Mg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.8";
        hash = "sha512-kOOuClCiRSu4qzUzBSnSQJiUtvZb6P0HB/005dDLB7hqVB0AtYRp7qu7qi0y5nYx/c6c0vdBqtyPMPkRx3NXGQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.8";
        hash = "sha512-RL39h0pyBnVYPshzvJOJtlbmdKvUvuWgf+tHBzl455jZqfwt7RsPf2WvROXCME0alrExZB6g3VSNbHhoFIo5CQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.8";
        hash = "sha512-v12pAEBEbWm651O1lVlTZS1NyM/mEhORJ0JcVnEJQpS5u317/uDdqZ7LknIppwQJfqhF2rIg02jS3yElfg8O9Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.8";
        hash = "sha512-GfVFJvhYUoJI4WbvOiAgMT4HS1+gMTizEXRuxlL6nmI7fVJNReIWOB3LsEBAaZOJbqBoGtciwVU7Oeu+nsOekQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.8";
        hash = "sha512-+XMW1cOzIwTSTcnam+tlZPa80BHlvugmxATXttjXY1u1DlJJXZCBHiE0cjCeO99k9VpwFr4g9MRHKgfJcNHKIA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.8";
        hash = "sha512-tGARYv1U56BWPK0A3/2KmtYNPBSovSxIRVEP/7hh2d8kFbszy3RqzKaFNz4Anf3ZfNHGMrMK2A5DvqEIxR83eA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.8";
        hash = "sha512-4slzmfzzj8K05cua+22dKz5OwNyYxEBXUzvosh/+jKmgEFpug74PPdTp2sgYliRUxUO/o1O3mWcXxMgp510k2w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.8";
        hash = "sha512-3VG/IV40RDsfc1F84fqE4e9t2MZG24pT29acsLpIeIt0K8GbfTFG9yPDK8/XXWqAqDSdVuVrLzQKHHFbN1hFVg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.8";
        hash = "sha512-QIrPBAMJx0FBhFDMTwjwKm0Wp32egd3Zb6Fy454VkhWKq+bHZStSVVeLIfNnpemqZn5ULkmCQQWoOooAw21I7g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.8";
        hash = "sha512-kauELS7o6BPUFsLueozrv/dtUgY3HYlK8xxlsWkQNMILiTWhmkNoXyptjFAc8sCdthPTXryws5DFBg4A+kxmYQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.8";
        hash = "sha512-1C0R3FapqJo3Cu+DyMX0mwKVFTRtJnQNtQ0TOWEnT1N8lH/PRDsZH+tHal3U7/PkdWY9D1FmbsKQ7uxZNOmeKw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.8";
        hash = "sha512-4p6EKTtSGhY4WV3XbdNVsNnWl7JvZkzmCBJImCIqY4eB0kV8BpqbNCO0kopi7gNmNGWsp97yPI4D3HuFi+IQHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.8";
        hash = "sha512-opZhwxdkU3wGOc42sLvsaoEfZ6cIzB0VfYlTowUeLqISP6Bw1YLE2x9y5IXjVHbRp6sKyIDQyrs45h4+MzLTMQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-5vJoOboU6uFIKZxF+oLVoCg7kuH+94YtC+nrO7l8YWdwba2oyWTPXoAfM6HnbzY/g5Omcc8oUNlKRZdwBuGBXg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.8";
        hash = "sha512-LxFcfH3yCeCTCu4YY0Rw4ZikgDqTD4TTZ19SZSqD69BDw74dKxcmCrQ9/A4d0DAFiqKEMMKTk3EVZ+Bqo/jVHw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.8";
        hash = "sha512-tyRDrV53rTqdgEZNeWnLqOUpHuTdN0DwWuo726hpftJS0gqh+HpZpGazuzePUToD27O7gNx8Z6+eUbqUvpldKg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.8";
        hash = "sha512-jH9WiOhUASzf/3XNOQGZtmkd4Zb+3qjhTB0qItNQO+HqJV8QZI/4XSrK6xEnoJS2J75N8vg/SDCTRi3BbR/qew==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-ldyC7aYLVx8PBpT9/SJw6Gi4pd6fEEMPCwxXpjUPtmhQVqjHKOtSeyt4mERDGlJBY5egNzHkF5Rc99yca20Y9w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.8";
        hash = "sha512-kuP8TvuVRSUqTFW+Ui5IfVA8ewaRkerGRW/5ktUnViqtCPQsjkvxLxlWqt1SO4sRW57q9y+QZNDO2dHdNCTd7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.8";
        hash = "sha512-+Iz4IIEdJhFUKsbzFn12YR9lGs3O5XAuXw1e4M4wzzVyoix1J/O7JE/p6Ep/MxdWUrud89hledyBgbk2A7tLEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.8";
        hash = "sha512-EKY7/AGlcUsgcMTm+0XJQtGZUH3MXQiIHaUsgK4UvugRzVAdqvwkSAs0un1mc4evvzTgWzMl9Yp8HapVWIMdpw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-pnIOiulipfx52mhy96M3v21YBsDYfzLJ21hr7tHCNaWtnBsr5dsnIfVNPUvaQQ2QJcadmrkoyhk18Dmb3QTmog==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.8";
        hash = "sha512-lzTfzT1Yd2o4KG8z+qu+CwJ1dNV2RhKOrypH6wIRHRd1ewTE3fLTOesq/OAhSJswIxjyG1g0a4K1kL98UfhKlA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.8";
        hash = "sha512-v2Gg1viOsyHEuZT56c2P0zVUFpZGrYjdzXIsQejjAd6aRGu3Xl23sRob5cM49p4VOq1Ywv8sHAB1lhVwa7Mxjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.8";
        hash = "sha512-jcMcr02ix+UM7wfSuSHGO/ZVbjDllhEQo0G6hPvL0n+8qQAu7p694JbFCVO+1h+wMOgudlFOBPLSb8ucTHb4Mw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-rephD4BBZWGzDM0nBn/IJCKyUaHhFFweXlZDQg7SzADACJDhr7pnAXr6WBDWBOZvtoScDO42W9SXBxebLlee0w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.8";
        hash = "sha512-Fdc0fvuu9ufeF05mPezAlQGjNw48O0050itpfpc2xaPz6Tkmt4t4QS46iHKUlek3eosQo+TWgKr8+ydA2rTtiQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.8";
        hash = "sha512-IbAy/N9knqt52d8Jg0ZPlht8PLGlxFrkUFGLOu9q1B6wyNAxcr+SNcAuqIQndV2aiC1JX1LxF+Z/RtR/dllmMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.8";
        hash = "sha512-eiuv/paMs3fiSFeGtP6EvmappnNAPl6oSWJJGPPcGCyjHKlvbvXXAGB4bo1gh08bDfyh42y9tzkFjj+N3eoJ8Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-n3582g9jXAzHDeBllHPjaihaGd8Q5ZMKgSh/2NpVB0SRw3Ie7jCHBloadFAqsz4CbMqBqz9bcwWJSs3UelF6Cg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.8";
        hash = "sha512-7Iu6w3otpfLf3PDvtus6k0DHYfyFiZ4/FrltO/3+7CPhYYNWtz69/CS7zMUbSebr47CMtGxDHa7sgwRhuQ0udg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.8";
        hash = "sha512-2MV4Mm2P0a7Xj33qe2DhxcUxORg4rOBx1MPrmFScypuzqwlcm7Ky6ValuVodGVAeziqxewG+TwEfQ+tlQtKTKw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.8";
        hash = "sha512-jx7ySFpxyeGIGu2e/RwWI5Qp0/Qi+7LLAnGa3p2ErCbEmx8cQpfzGijxKekjEhtOVIEFt3XDVUBaiShiFCAp7w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-DAzBxlAn4kHG5UPmIIcNzLyVOFWmsSw3FBFE2k1gFBINRJQxsch/OYGeHJOvcV9AE1kCdOpwfvXkAuYsZ1yqJw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.8";
        hash = "sha512-7/dik29myG9DpI57mqgQUZKBqUTch4gJPUVTsGwCrpX/+2fCRUMh6wTDZKVJigQmIEAOPDmjVjLsB/46QhCDdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.8";
        hash = "sha512-bCH5hRqBpZXNuNO2xmhx4EmZtP6qvH7qlNP3neR9LhaRR2V6ttRwH2LOPZNaMiroNo1V4T+aDYsqP+4blJ7vFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.8";
        hash = "sha512-VKdx5FBTl0DJSx3tXhSpEQmveT3plCbxvWmDiNmpZ1mroNunXT8F5HLfpnHBLfJ/AYoA/aR/rDDLK5521EjScg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-Jzq382A89/24L3mRaWqD7SBzBO8Q3gFPksq5xnMrkt/kvTES68kMChvime8TE9Swq22vQNdmWc7Oleco/VsocA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.8";
        hash = "sha512-gsCIp/l+fBFkghgipU7AlJmbN9mBioZ0gTJ/71Ue3brd8oT+JTHljk7Byth43Wz/QHqvW6NtMfB/KMba+Ovcrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.8";
        hash = "sha512-1bPBwHyTuD+bM2mIs/lDzPSbxUv3td2KvxqoslykADooEXMkEldhP4h6GRJabTygMKzpG36kaUbVhmY0Z3YzQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.8";
        hash = "sha512-iOBFiwX+SH3Sz6Re+xDVTUrdtNzD+A0w4CgmhKyvGEm+S2gXHKptcYTfuHPWxgXkewJfLFGb6SNjcdqpbC2ETA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-KZKJ7e4Mq8E06pMAtTnyjmk/SqNEEMLHcbESLJ7ggVedHcJA/elymIGepIZP9jSwQjtI1v7ggIc3g9C63QDrtA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.8";
        hash = "sha512-NJTDO+UX/6NpAORJ+AsL177tpbgCTAaSavaDKKTkz8wwdesjcT0OEMa6XveImmOA4KDQsD9dyPZk8CY+y/+6EQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.8";
        hash = "sha512-LJ3kCcdyacCBeii37XDf8uSWGrkEa2rpwyCQRnQdPKDQKs3QemPqXBiodbUGe40jxsWeg/aTh68ux3E0w5A6ug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.8";
        hash = "sha512-r5eVgUvphRSxeAkmjQsbSQI7phyaFklVs4Mwu4Qgr4HAu+UkZI8UJi23jKbK8B5iUuqj+L2bE6/hNti1XIvQNw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-KpD57JOPE5YykXteBFpIhQAs5TVrJKWxryEPpW9jdr0K73gGClquXUexYGjiHk++EPTr59aRKcUKQrNyZXOmDw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.8";
        hash = "sha512-gXQpEX6W6CWyUpmX1zbRE4pGR3c0EJLbBqkXOpqiPpLc/qh6in+tC4MhGWesCNLOsZXf0nlFikBUouKeX4heUA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.8";
        hash = "sha512-shIJcIsVRmlyuiBNu/OJ0cl3YS2g8LAUwN+r42Jin+HZYkZE5Esf3Zl6KNrBG4JdhZD32jNZ9JE/m0uB0PbLRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.8";
        hash = "sha512-ubHRXN/19HpDTzlaXIAJUVOpfgOOnsPwIwxk+rlaO1nv2w74aa8dUQGtPeqNkpo87CSdwpc1uaDe79NLGeY0HQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-RFXToE31qPxev1Ei0hosMf8jN9U9hivDSiTWGFaBg8Bjyeai5YZ4JcYfNi3yNyaBKrra8sdPtcKMBHn3JtRnTw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.8";
        hash = "sha512-Hq2Jkbv1dN5A6hojoNpZYsWdHlmALRRZSAxWY6y/bYfwczY7xRXPcwDWcXg3TgURZ3tYDjLAZmKvmkxe8CGOWQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.8";
        hash = "sha512-iAKhXmVqwtB1oU09QaFgY1rHegt+GczpjlpmKibZCGjewULMevVnFaNTUGgnNKfnFziEy9Ou9khGyRjumrDbsg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.8";
        hash = "sha512-JTcyKAl8lxnWoIptRAw9qdF1wfxKQb6JNs898g/HJQIOBQCuW6DkJy7TAn6QHhJPQ0o5KS4LtG/wCTs05IO3+g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.8";
        hash = "sha512-SkW+QLlwQVY3G1yYd8ECVY22NtMo+gkGvnzOSQqsQ91e1Ihf8kGtAQ8mX8/NNmM4ekj7XuwsdGK6mt89HNoFXA==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.8";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.8";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.8/aspnetcore-runtime-9.0.8-linux-arm.tar.gz";
        hash = "sha512-qZREscunr0rNEtmtQSb+Ss3fLvDgK5md4LwYU3QuE27/sD7XrcKgpHBi0AUbMXkyCkf9PSOdD7hvl3W3PeQ9Gg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.8/aspnetcore-runtime-9.0.8-linux-arm64.tar.gz";
        hash = "sha512-zx5y9LMnuTwaw/Le+cqDvuJ6QI5bWRP4TtlUz9bEY52hZk/j9OOSWIPbd+0p+lNkucqK83lvM8pzpMt0hOMmvA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.8/aspnetcore-runtime-9.0.8-linux-x64.tar.gz";
        hash = "sha512-CK/fkk0A+HW0TMTv9otV+5tj5Mxo5rXN6HPaK86cW19BIOhptqHf3qSrEEqwrIeD7xV3tNMnWq6JmlPNiBMPHQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.8/aspnetcore-runtime-9.0.8-linux-musl-arm.tar.gz";
        hash = "sha512-RND6DTb5z/mT9wie/TsrPg5g1AO8K1o5URa+fWtDqCRx4qu0TNFwJGStMCM3vD4M5J4kLwL6FKEUKI8PimYilg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.8/aspnetcore-runtime-9.0.8-linux-musl-arm64.tar.gz";
        hash = "sha512-5ExwXEbRT8tXVPF7o0bqKHb8G9tEv6A3K0jAmXkZmnaOuCdmuOfiK53AGnw4uFPvG1P4stxX3vFbPcJf0I6yVg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.8/aspnetcore-runtime-9.0.8-linux-musl-x64.tar.gz";
        hash = "sha512-5D3IU1sy+f0Xtrgc+7l1vkbwn3eTAkBC5i/htJnbZu6tbbESylH+/ZojxnbLbcsBkcWYXC9TQGmB9OFfC272Zw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.8/aspnetcore-runtime-9.0.8-osx-arm64.tar.gz";
        hash = "sha512-T+od1lxCvVoGUOG+m2K8ygX0jKLI0bWX6VjGX5TfZZZmUHx+twPdnQbyStAHmI/pKvc2P+2z20lQK4pcVPmthA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.8/aspnetcore-runtime-9.0.8-osx-x64.tar.gz";
        hash = "sha512-cOgD8+BEnqxWQ43hL4dx8yJgcpbuU+DmiWziEfXa/gg/XzP54sdsVAEsk/wblR4MFjDJdEd3fcRovvn7EZSfww==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.8";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.8/dotnet-runtime-9.0.8-linux-arm.tar.gz";
        hash = "sha512-XitlwgOdZuHGyasekrvUh/zRvXphI8FwvqzbHOJGiNc0noSuizhr11i9JHK3NtGO3qg3DMY+tV+sCqs1ZYgP3g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.8/dotnet-runtime-9.0.8-linux-arm64.tar.gz";
        hash = "sha512-MBXpX/DDc7jVlJHPHDIMgPTsdBjWNAC/ZQjU4l5xpH2yhUkVNIqxhuWKktWsLyD77BPWPfXF9gH/SvXynD2c0w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.8/dotnet-runtime-9.0.8-linux-x64.tar.gz";
        hash = "sha512-92luoqMKErrQyPcyGsQoQ87TBxhNiUyUpkyFKJs88wk23zc/9YVDzpt3YFqAJD0fx3e8lZV1Y0qq2cqogPv4Zg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.8/dotnet-runtime-9.0.8-linux-musl-arm.tar.gz";
        hash = "sha512-sQh1B3IPZCmiSihUVMzVSokifIXcsb3wwjQkdyMJR8kc4/FmW+diYRNqk1yXPUvtjF0c7AiX+GsJMWuq7h27Qg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.8/dotnet-runtime-9.0.8-linux-musl-arm64.tar.gz";
        hash = "sha512-AYQXIV58CoKhnsfhGaQ4vKkYucRI84SyffuH+YGpiKwhTFdvKKrv7IV0WwBc/3C/0pm+Mb8k4xlVOKTpH6bv4w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.8/dotnet-runtime-9.0.8-linux-musl-x64.tar.gz";
        hash = "sha512-oAgYUGPY80Y15AMoMTrzHnuuI5yNokcmsf8gEuyTDDLvDcDWcpKuvE2FMNKyb6Rs/7M5PPFrzfZsEOqINFitcQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.8/dotnet-runtime-9.0.8-osx-arm64.tar.gz";
        hash = "sha512-+n7QPNWl4FVfZfjwEBx3Yua/2gBfpJWvoSZRjU1ByXNMZX/DWc+A+Qv2+/GGwmrwOBnbrdUlHpftTL0Ej8J7OA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.8/dotnet-runtime-9.0.8-osx-x64.tar.gz";
        hash = "sha512-M5jxrKx2R+Jc0kdoBMWtJkyhjhUtDiKzLr2mvV13RMHpMqqQhq7NN5S4208vcl7SD/3UT/YV5ygaCsXdlQc7nw==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.109";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.109/dotnet-sdk-9.0.109-linux-arm.tar.gz";
        hash = "sha512-QJEtXxu/WbBx0uHTHsHZq93b893GSzIz58fpFpawI+H6eglHJdOZW5MciAA4Ql7OvAXwE/dZYye/SWaSnpgBtQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.109/dotnet-sdk-9.0.109-linux-arm64.tar.gz";
        hash = "sha512-Kd/68u4iQCxgHD4cvvNoKbow/jLpdrMfJH32BaFF76KafiPfUJ7YH6mm0T8eVYFeKlkiA6p5wudniNkBpuGrWA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.109/dotnet-sdk-9.0.109-linux-x64.tar.gz";
        hash = "sha512-zDhqjnAJhVpumjqKFT2htc5UwuC3t64wVEXunw1XNVGN/u8Nj/MqREeC4180oxZ1ck4EBTYAGnbJ3Bt1W1omBQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.109/dotnet-sdk-9.0.109-linux-musl-arm.tar.gz";
        hash = "sha512-62kBlt/TQmebHm0Mw/UAZ74dDypu+RFx/rcS5MSkkb7jgeNQBjgpDh5Z6TP3f1fMZL7ZLK1u6h62VnarikxmoQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.109/dotnet-sdk-9.0.109-linux-musl-arm64.tar.gz";
        hash = "sha512-CZ+bh0Cjx1hBU8KWFg/Jb8y8GMfCRnjv9+ZCXWAsdw1TTE8ttWOTPNT+XJ6y1A99A6H2mu9em5RZDzYM9qFCgQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.109/dotnet-sdk-9.0.109-linux-musl-x64.tar.gz";
        hash = "sha512-FonLs6wXs3SQOyFKFz8kFgByrlfMXRMH9bJgUbb/BAV3K2A7amx+8ZUvc3sYyfO5dvc1S4S4mra/Fb4g3QY2tg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.109/dotnet-sdk-9.0.109-osx-arm64.tar.gz";
        hash = "sha512-ri68P3dAq4gK9W4209Kh7lpU/BErb9zCUo8sjFmAjTZHbV+rXNqn0lgZsOSpARdF86nlxyaSzZMrMA62/YX1rw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.109/dotnet-sdk-9.0.109-osx-x64.tar.gz";
        hash = "sha512-O3Lvl5RoYzAitNIi2jGnP45zjR6n1ENAghXecxGCTk8lycbdGTxEAUwmVZIoKTiVwWSlGTTzB+FT2SfnDLbztw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
